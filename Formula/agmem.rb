class Agmem < Formula
  desc "agmem: agent memory over MCP. The `agmem` binary."
  homepage "https://github.com/AlfoldiMate/agmem"
  version "0.1.5"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/AlfoldiMate/agmem/releases/download/v0.1.5/agmem-server-aarch64-apple-darwin.tar.xz"
    sha256 "e63ac7513f189f852f98c48edefefcd1bae354ea5248f3625aeaf4820a82e1d1"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/AlfoldiMate/agmem/releases/download/v0.1.5/agmem-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fe154faa2460555cd29e2e9ee59058aa396e0dbe9007bf17136695e9d2accdf9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AlfoldiMate/agmem/releases/download/v0.1.5/agmem-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "be4c97664d163c9c10725a20178b9fdee6876213aafb237b3335559cc57ed23e"
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
