class Feza < Formula
  desc "None"
  homepage "None"
  version "0.5.27"


  # Python package - install via pip so wrapper script can import it
  depends_on "python@3.11"


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joshuboi77/Feza/releases/download/v0.5.27/feza-darwin-arm64.tar.gz"
      sha256 "33a22d0d71ea50fa20ac7590daab3ea78e7c97c26d5f29f74cac115e6732241e"
    else
      url "https://github.com/joshuboi77/Feza/releases/download/v0.5.27/feza-darwin-amd64.tar.gz"
      sha256 "ed90d23771565d2d74450fb68504f7efd1d0481f7029bc111990fea5456df0a0"
    end
  end

  on_linux do
    url "https://github.com/joshuboi77/Feza/releases/download/v0.5.27/feza-linux-amd64.tar.gz"
    sha256 "ec1a3f81b596a30dfccfae8755492db5c5ce24d780fcbd62a374558e76b48bb5"
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
        File.write("setup.py", "from setuptools import setup; setup(name='feza', version='0.5.27')")
        system python3, "-m", "pip", "install", "--prefix", prefix, "--no-build-isolation", "."
      end
    end

  end

  test do
    assert_match "0.5.27", shell_output("#{bin}/feza --version")
  end
end
