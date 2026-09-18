class ClaudeUsageTide < Formula
  desc "Menu bar readout of your Claude subscription usage"
  homepage "https://github.com/25qi/claude-usage-tide"
  url "https://github.com/25qi/claude-usage-tide/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "960ccbac556ee73e3d7f09579d00554ae3e0495e32ea171f3a25632259888f8b"
  license "MIT"
  head "https://github.com/25qi/claude-usage-tide.git", branch: "main"

  depends_on macos: :ventura

  def install
    # SwiftPM sandboxes its own build, which cannot nest inside Homebrew's.
    system "swift", "build", "--disable-sandbox", "-c", "release"
    system "./bundle.sh", ".build/release/ClaudeUsageTide", prefix/"Claude Usage Tide.app", "--homebrew"
  end

  service do
    run [opt_prefix/"Claude Usage Tide.app/Contents/MacOS/ClaudeUsageTide"]
  end

  def caveats
    <<~EOS
      Start it now and at every login:
        brew services start claude-usage-tide

      On first run macOS asks whether `security` may read
      "Claude Code-credentials". Choose Always Allow.
    EOS
  end

  test do
    app = prefix/"Claude Usage Tide.app"
    assert_predicate app/"Contents/MacOS/ClaudeUsageTide", :executable?
    assert_equal "true",
      shell_output("/usr/libexec/PlistBuddy -c 'Print :ManagedByHomebrew' '#{app}/Contents/Info.plist'").strip
  end
end
