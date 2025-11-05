class Feza < Formula
  desc "Plan, build, publish, and tap releases for CLI apps"
  homepage "https://github.com/joshuboi77/Feza"
  version "0.5.18"


  # Python package - install via pip so wrapper script can import it
  depends_on "python@3.11"


  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/joshuboi77/Feza/releases/download/v0.5.18/feza-darwin-arm64.tar.gz"
      sha256 "aec4d010b559bb3ec891500ddc6ab078909f97d82a449c55306d58472620e52a"
    else
      url "https://github.com/joshuboi77/Feza/releases/download/v0.5.18/feza-darwin-amd64.tar.gz"
      sha256 "24257cbe936bd8ce5e654586751a6de7bbba01ae446c5a2d9186ae8f8880e58e"
    end
  end

  on_linux do
    url "https://github.com/joshuboi77/Feza/releases/download/v0.5.18/feza-linux-amd64.tar.gz"
    sha256 "fe8c4e8884c9b4b6d6ba272981ed90a06eca8be82961da1ca0734a539b2d7ea8"
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
        File.write("setup.py", "from setuptools import setup; setup(name='feza', version='0.5.18')")
        system python3, "-m", "pip", "install", "--prefix", prefix, "--no-build-isolation", "."
      end
    end

  end

  test do
    assert_match "0.5.18", shell_output("#{bin}/feza --version")
  end
end
