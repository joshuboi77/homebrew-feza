class Feza < Formula
  desc "None"
  homepage "None"
  version "0.5.20"


  # Python package - install via pip so wrapper script can import it
  depends_on "python@3.11"


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joshuboi77/Feza/releases/download/v0.5.20/feza-darwin-arm64.tar.gz"
      sha256 "1e5d381a2c1b523c381d46e129ff774b18da3529b42a1cf788727dc3595808ee"
    else
      url "https://github.com/joshuboi77/Feza/releases/download/v0.5.20/feza-darwin-amd64.tar.gz"
      sha256 "f3d2a2ca0b148eba2bdef3d291f9d68c59343e03a8da137f269db0129dec7116"
    end
  end

  on_linux do
    url "https://github.com/joshuboi77/Feza/releases/download/v0.5.20/feza-linux-amd64.tar.gz"
    sha256 "32c3d45798bf972bc214548c2ec7fa51e6fadd354e42475575695588f6ca0d2f"
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
        File.write("setup.py", "from setuptools import setup; setup(name='feza', version='0.5.20')")
        system python3, "-m", "pip", "install", "--prefix", prefix, "--no-build-isolation", "."
      end
    end

  end

  test do
    assert_match "0.5.20", shell_output("#{bin}/feza --version")
  end
end
