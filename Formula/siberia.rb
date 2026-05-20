# typed: true
# frozen_string_literal: true

class Siberia < Formula
  include Language::Python::Virtualenv

  desc "Supply-chain hardening for pip, uv, npm, pnpm, and Cargo lockfile auditing"
  homepage "https://github.com/cavanaug/siberia"
  url "https://github.com/cavanaug/siberia/releases/download/v0.3.0/siberia-0.3.0.tar.gz"
  sha256 "3f86fcf9bc7c1f9f0a7107153a23f1f0c93e495dd5d9daec315fa2f11d3ac31e"
  license "MIT"

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "0.2.0", shell_output("#{bin}/siberia --version").strip
  end
end
