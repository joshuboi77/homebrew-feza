class Feza < Formula
  desc "None"
  homepage "None"
  version "0.5.25"


  # Python package - install via pip so wrapper script can import it
  depends_on "python@3.11"


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joshuboi77/Feza/releases/download/v0.5.25/feza-darwin-arm64.tar.gz"
      sha256 "fee618bacb7c7b4cabd6675f45252e372d883c5a60c1ee33457607763d193435"
    else
      url "https://github.com/joshuboi77/Feza/releases/download/v0.5.25/feza-darwin-amd64.tar.gz"
      sha256 "ea55e5b650345ea399d0d46dfa1cfcf1b9b722cccecd47e9bb2cd1e748c53ab4"
    end
  end

  on_linux do
    url "https://github.com/joshuboi77/Feza/releases/download/v0.5.25/feza-linux-amd64.tar.gz"
    sha256 "5d6e9f6c929ff71b9e6ce74c5dc923cea13b038329e685164c2a3c945e9848e4"
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
