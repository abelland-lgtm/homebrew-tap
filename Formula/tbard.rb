class Tbard < Formula
  desc "Audiobook manager and listener for the terminal: your Audible library, chapter-split downloads, playback with mpv and position sync"
  homepage "https://abelland-lgtm.github.io/tbard/"
  version "0.1.0"
  depends_on "ffmpeg"
  depends_on "mpv"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/abelland-lgtm/tbard/releases/download/v0.1.0/tbard-aarch64-apple-darwin.tar.xz"
      sha256 "e25396e1efe9ce43e4562c257dd839ab4422e3f7e10c2143674f6e290d02de4b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/abelland-lgtm/tbard/releases/download/v0.1.0/tbard-x86_64-apple-darwin.tar.xz"
      sha256 "07c43d5626cf35b47ddd7fa647551f2e22db384df739da7ea82e6c90a07dc5e5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/abelland-lgtm/tbard/releases/download/v0.1.0/tbard-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "355337ccbebb3e79dd6f53774246dc3d7324ce414326cb6ccd7fc4e6b459378e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/abelland-lgtm/tbard/releases/download/v0.1.0/tbard-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b52ad6d8166e9da78a169afbad79f171e622a3c81876094da5595cd2d0245758"
    end
  end
  license "GPL-3.0-or-later"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
      bin.install "tbard"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "tbard"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "tbard"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "tbard"
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
