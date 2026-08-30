class Agmem < Formula
  desc "agmem: agent memory over MCP. The `agmem` binary."
  homepage "https://github.com/AlfoldiMate/agmem"
  version "0.1.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/AlfoldiMate/agmem/releases/download/v0.1.2/agmem-server-aarch64-apple-darwin.tar.xz"
    sha256 "4383df75914f61dfc6a1bc8b3a9f4d69a0a4075c024a96c4b22c6d6727df5c12"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/AlfoldiMate/agmem/releases/download/v0.1.2/agmem-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "39bf9c71d2c4c893ebade1b16e27befc77ba861c1682353840a46563f8eb1da5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AlfoldiMate/agmem/releases/download/v0.1.2/agmem-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "454550c42a745d1d0cf3e5d22d1783418ea0293d0f2a4fd340f05917f69c7f6f"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "agmem"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "agmem"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "agmem"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
