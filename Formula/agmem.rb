class Agmem < Formula
  desc "agmem: agent memory over MCP. The `agmem` binary."
  homepage "https://github.com/AlfoldiMate/agmem"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AlfoldiMate/agmem/releases/download/v0.1.1/agmem-server-aarch64-apple-darwin.tar.xz"
      sha256 "bb7716f6a0fbbc670a34e18dc433e8a9745216d07096644aa564c9340fea541a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/AlfoldiMate/agmem/releases/download/v0.1.1/agmem-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "13f985d2c9e633860d7c2e9bef9bfea280bc58b913e0b80567a5e69d8afdf7dc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AlfoldiMate/agmem/releases/download/v0.1.1/agmem-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f3cd648ac74cc219c1d9292ce85b5f4de7eb2dff1519c68df135125d533d98a3"
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
