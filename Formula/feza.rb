class Feza < Formula
  desc "Plan, build, publish, and tap releases for CLI apps"
  homepage "https://github.com/joshuboi77/Feza"
  version "0.5.17"


  # Python package - install via pip so wrapper script can import it
  depends_on "python@3.11"


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joshuboi77/Feza/releases/download/v0.5.17/feza-darwin-arm64.tar.gz"
      sha256 "deeab27b861390f3aa75ca91e422df489aadec735c3df7712fbbc8738437cde2"
    else
      url "https://github.com/joshuboi77/Feza/releases/download/v0.5.17/feza-darwin-amd64.tar.gz"
      sha256 "6e8b6fa4883d2f8f05a6c040faf773e9f844b846edd26ae809d259d7020c5bbf"
    end
  end

  on_linux do
    url "https://github.com/joshuboi77/Feza/releases/download/v0.5.17/feza-linux-amd64.tar.gz"
    sha256 "470b86be25b06bc9cec4cbae5d20c24989b4f24fb21a8d7f50b1c27fa6141dba"
  end

  def install
    # Install wrapper script from bin/ directory in tarball
    bin.install "bin/feza" => "feza"

    # Install Python package so wrapper script can import it
    # The wrapper script does "from feza.main import main" so package must be installed
    # Package source is included in the tarball, install from extracted source
    python3 = "python3.11"
    if File.exist?("pyproject.toml")
      # Install from pyproject.toml in the extracted tarball
      system python3, "-m", "pip", "install", "--prefix", prefix, "--no-build-isolation", "."
    elsif File.exist?("setup.py")
      # Fallback for setup.py
      system python3, "-m", "pip", "install", "--prefix", prefix, "--no-build-isolation", "."
    else
      # Try installing package name from bundled source
      package_dir = "feza"
      if Dir.exist?(package_dir)
        # Create a minimal setup.py if needed
        File.write("setup.py", "from setuptools import setup; setup(name='feza', version='0.5.17')")
        system python3, "-m", "pip", "install", "--prefix", prefix, "--no-build-isolation", "."
      end
    end

  end

  test do
    assert_match "0.5.17", shell_output("#{bin}/feza --version")
  end
end
