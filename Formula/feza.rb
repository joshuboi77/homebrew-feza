class Feza < Formula
  desc "None"
  homepage "None"
  version "0.5.25"


  # Python package - install via pip so wrapper script can import it
  depends_on "python@3.11"


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joshuboi77/Feza/releases/download/v0.5.25/feza-darwin-arm64.tar.gz"
      sha256 "0ba8f1527fda48475ff99540faba464727fe2882fb49d0203b1198a03f6fc273"
    else
      url "https://github.com/joshuboi77/Feza/releases/download/v0.5.25/feza-darwin-amd64.tar.gz"
      sha256 "28687e9a18d507846fba7b9d881ae5b36c9ebd70f92ee015a01b054ce2bab026"
    end
  end

  on_linux do
    url "https://github.com/joshuboi77/Feza/releases/download/v0.5.25/feza-linux-amd64.tar.gz"
    sha256 "31019f255800386a793736389d9629f0c422924c1e25ba27d9ac062bac86dc2e"
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
        File.write("setup.py", "from setuptools import setup; setup(name='feza', version='0.5.25')")
        system python3, "-m", "pip", "install", "--prefix", prefix, "--no-build-isolation", "."
      end
    end

  end

  test do
    assert_match "0.5.25", shell_output("#{bin}/feza --version")
  end
end
