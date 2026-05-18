#!/usr/bin/env bash
set -euo pipefail

MIN_AGE_DAYS=2

while [ "$#" -gt 0 ]; do
  case "$1" in
    --min-age-days)
      [ "$#" -ge 2 ] || {
        echo "Missing value for --min-age-days" >&2
        exit 1
      }
      MIN_AGE_DAYS="$2"
      shift 2
      ;;
    --min-age-days=*)
      MIN_AGE_DAYS="${1#*=}"
      shift
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

case "$MIN_AGE_DAYS" in
  ''|*[!0-9]*)
    echo "--min-age-days must be a non-negative integer" >&2
    exit 1
    ;;
esac

ROOT="$(git rev-parse --show-toplevel)"
FORMULA="${ROOT}/Formula/siberia.rb"
REPO="cavanaug/siberia"
API="https://api.github.com/repos/${REPO}/releases/latest"

current_version() {
  ruby -e 'puts File.read(ARGV[0])[/^\s*url\s+".*\/v([^\/]+)\/siberia-\1\.tar\.gz"/, 1]' "$1"
}

release_data() {
  curl -fsSL "$API"
}

CURRENT="$(current_version "$FORMULA")"
RELEASE_JSON="$(release_data)"

eval "$({
  printf '%s' "$RELEASE_JSON" | ruby -rjson -rtime -e '
    release = JSON.parse(STDIN.read)
    version = release.fetch("tag_name").sub(/^v/, "")
    published_at = Time.iso8601(release.fetch("published_at"))
    min_age_days = Integer(ARGV.fetch(0))
    age_days = ((Time.now.utc - published_at) / 86_400).floor
    assets = release.fetch("assets").to_h do |asset|
      digest = asset["digest"].to_s.sub(/^sha256:/, "")
      [asset.fetch("name"), digest]
    end

    tarball = "siberia-#{version}.tar.gz"
    digest = assets[tarball]
    abort "Missing release asset: #{tarball}" if digest.to_s.empty?

    puts "LATEST=#{version.dump}"
    puts "PUBLISHED_AT=#{release.fetch("published_at").dump}"
    puts "AGE_DAYS=#{age_days}"
    puts "TOO_NEW=#{(age_days < min_age_days).to_s.dump}"
    puts "TARBALL=#{tarball.dump}"
    puts "SHA256=#{digest.dump}"
  ' "$MIN_AGE_DAYS"
})"

echo "Current version: ${CURRENT}"
echo "Latest version:  ${LATEST}"
echo "Published at:    ${PUBLISHED_AT}"
echo "Age (days):      ${AGE_DAYS}"

if [ "$TOO_NEW" = "true" ]; then
  echo "Skipping update: release is newer than ${MIN_AGE_DAYS} days"
  exit 0
fi

if [ "$LATEST" = "$CURRENT" ]; then
  echo "Already at latest: ${CURRENT}"
  exit 0
fi

ruby - "$FORMULA" "$LATEST" "$SHA256" <<'RUBY'
formula, version, sha256 = ARGV

content = File.read(formula)
content.sub!(%r{url ".*/releases/download/v[^"]+/siberia-[^"]+\.tar\.gz"}, %(url "https://github.com/cavanaug/siberia/releases/download/v#{version}/siberia-#{version}.tar.gz"))
content.sub!(/^\s*sha256 "[a-f0-9]{64}"/, %(  sha256 "#{sha256}"))

File.write(formula, content)
RUBY

echo "Updated ${FORMULA} to ${LATEST}"
echo "  Tarball: ${TARBALL}"
echo "  SHA256:  ${SHA256}"
