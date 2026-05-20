# typed: true
# frozen_string_literal: true

class Siberia < Formula
  include Language::Python::Virtualenv

  desc "Supply-chain hardening for pip, uv, npm, pnpm, and Cargo lockfile auditing"
  homepage "https://github.com/cavanaug/siberia"
  url "https://github.com/cavanaug/siberia/releases/download/v0.4.0/siberia-0.4.0.tar.gz"
  sha256 "f5eb600b615408ecaf7e05fa03999de782c936b77e3995f9d1fd942ea4acf519"
  license "MIT"

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "0.2.0", shell_output("#{bin}/siberia --version").strip
  end
end
