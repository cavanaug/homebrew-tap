# typed: true
# frozen_string_literal: true

class Siberia < Formula
  include Language::Python::Virtualenv

  desc "Supply-chain hardening for pip, uv, npm, pnpm, and Cargo lockfile auditing"
  homepage "https://github.com/cavanaug/siberia"
  url "https://github.com/cavanaug/siberia/releases/download/v0.2.0/siberia-0.2.0.tar.gz"
  sha256 "98f33937e9ca68ec0d282aa46f3744e9de0e4440f1b67b8eb799cc8d64c2147c"
  license "MIT"

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "0.2.0", shell_output("#{bin}/siberia --version").strip
  end
end
