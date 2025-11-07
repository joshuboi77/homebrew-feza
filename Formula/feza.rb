class Feza < Formula
  desc "None"
  homepage "None"
  version "0.5.21"


  # Python package - install via pip so wrapper script can import it
  depends_on "python@3.11"


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joshuboi77/Feza/releases/download/v0.5.21/feza-darwin-arm64.tar.gz"
      sha256 "2b9913c9d81b7bbb5a43a7a42d664909d1def029f8503e2691145f21e6e2d5ee"
    else
      url "https://github.com/joshuboi77/Feza/releases/download/v0.5.21/feza-darwin-amd64.tar.gz"
      sha256 "241cbb70203f14d8902fd4292cad355897789e9d32fc305b61b731bf99b4593e"
    end
  end

  on_linux do
    url "https://github.com/joshuboi77/Feza/releases/download/v0.5.21/feza-linux-amd64.tar.gz"
    sha256 "efb51942b8e8e39059ee3ade47454b127d6f082aa8c4a0d3346e7932ded244f0"
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
        File.write("setup.py", "from setuptools import setup; setup(name='feza', version='0.5.21')")
        system python3, "-m", "pip", "install", "--prefix", prefix, "--no-build-isolation", "."
      end
    end

  end

  test do
    assert_match "0.5.21", shell_output("#{bin}/feza --version")
  end
end
