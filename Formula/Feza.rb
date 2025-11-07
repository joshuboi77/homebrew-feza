class Feza < Formula
  desc "CLI tool"
  homepage "https://github.com/joshuboi77/Feza"
  version "0.5.23"


  # Python package - install via pip so wrapper script can import it
  depends_on "python@3.11"


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joshuboi77/Feza/releases/download/v0.5.23/feza-darwin-arm64.tar.gz"
      sha256 "fd90287d6c592cd908cacd74176942b482f4bab2f8dd3a221401f61f7546f2ff"
    else
      url "https://github.com/joshuboi77/Feza/releases/download/v0.5.23/feza-darwin-amd64.tar.gz"
      sha256 "4e559eb9a420835a5c824c3fd6b90e6f253d857f6a5a14dc216153ffe21f822e"
    end
  end

  on_linux do
    url "https://github.com/joshuboi77/Feza/releases/download/v0.5.23/feza-linux-amd64.tar.gz"
    sha256 "6a78645a7b4c626465227635c19b7f62dd716926af6d7bb8613e6eb2a42c7329"
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
        File.write("setup.py", "from setuptools import setup; setup(name='feza', version='0.5.23')")
        system python3, "-m", "pip", "install", "--prefix", prefix, "--no-build-isolation", "."
      end
    end

  end

  test do
    assert_match "0.5.23", shell_output("#{bin}/feza --version")
  end
end
