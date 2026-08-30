class Agmem < Formula
  desc "agmem: agent memory over MCP. The `agmem` binary."
  homepage "https://github.com/AlfoldiMate/agmem"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AlfoldiMate/agmem/releases/download/v0.1.0/agmem-server-aarch64-apple-darwin.tar.xz"
      sha256 "764ebf9d2abe5d35642888483e709cd34a07a7e34f14fae0fbfd99dcc6da7575"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/AlfoldiMate/agmem/releases/download/v0.1.0/agmem-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6495713f65c93d830d89c2e8bd9b24e0b0a34bfe35ea89705c43399d6899e647"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AlfoldiMate/agmem/releases/download/v0.1.0/agmem-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b24492f2f4f9b5991ea4d41d50253d08b5035e48669ea9eaab395ba6e8a113ca"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
