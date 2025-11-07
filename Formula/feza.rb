class Feza < Formula
  desc "None"
  homepage "None"
  version "0.5.26"


  # Python package - install via pip so wrapper script can import it
  depends_on "python@3.11"


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joshuboi77/Feza/releases/download/v0.5.26/feza-darwin-arm64.tar.gz"
      sha256 "04df4dd1b2e86cab5cfdcdc622decc309445f6615e62d63e041c54dc299fd82e"
    else
      url "https://github.com/joshuboi77/Feza/releases/download/v0.5.26/feza-darwin-amd64.tar.gz"
      sha256 "bbd315c7c2326a04ae343daefc0f3c49f6a633b654e5697a184f4a3520ad65b8"
    end
  end

  on_linux do
    url "https://github.com/joshuboi77/Feza/releases/download/v0.5.26/feza-linux-amd64.tar.gz"
    sha256 "7f6349ee4c859013cc6e100c72ae4b654492e28f02e7a11ecd2c79d38842ccf6"
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
        File.write("setup.py", "from setuptools import setup; setup(name='feza', version='0.5.26')")
        system python3, "-m", "pip", "install", "--prefix", prefix, "--no-build-isolation", "."
      end
    end

  end

  test do
    assert_match "0.5.26", shell_output("#{bin}/feza --version")
  end
end
