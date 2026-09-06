class Agmem < Formula
  desc "agmem: agent memory over MCP. The `agmem` binary."
  homepage "https://github.com/AlfoldiMate/agmem"
  version "0.3.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/AlfoldiMate/agmem/releases/download/v0.3.0/agmem-server-aarch64-apple-darwin.tar.xz"
    sha256 "ec64697f0e6621b721e31559f22344d45d1985cedad421623929d1068d8d082e"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/AlfoldiMate/agmem/releases/download/v0.3.0/agmem-server-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "89110f40e59ba7573c2c7082b8e5ef8edfbc0ff76de974149dfb07e308af8bf8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AlfoldiMate/agmem/releases/download/v0.3.0/agmem-server-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "98385a538f6d9f0460a13cca1884843b53e191641da2db0bd5a02706b610f1ac"
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
