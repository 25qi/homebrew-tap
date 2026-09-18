class ClaudeQuotaBar < Formula
  desc "Menu bar readout of your Claude subscription usage"
  homepage "https://github.com/25qi/claude-quota-bar"
  url "https://github.com/25qi/claude-quota-bar/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "7bd09b5058d53a656ec7e7c39a1e49979d6bd1d03f1d69478f18909d000aedaa"
  license "MIT"
  head "https://github.com/25qi/claude-quota-bar.git", branch: "main"

  depends_on macos: :ventura

  def install
    # SwiftPM sandboxes its own build, which cannot nest inside Homebrew's.
    system "swift", "build", "--disable-sandbox", "-c", "release"
    system "./bundle.sh", ".build/release/ClaudeQuotaBar", prefix/"Claude Quota Bar.app", "--homebrew"
  end

  service do
    run [opt_prefix/"Claude Quota Bar.app/Contents/MacOS/ClaudeQuotaBar"]
  end

  def caveats
    <<~EOS
      Start it now and at every login:
        brew services start claude-quota-bar

      On first run macOS asks whether `security` may read
      "Claude Code-credentials". Choose Always Allow.
    EOS
  end

  test do
    app = prefix/"Claude Quota Bar.app"
    assert_predicate app/"Contents/MacOS/ClaudeQuotaBar", :executable?
    assert_equal "true",
      shell_output("/usr/libexec/PlistBuddy -c 'Print :CQBManagedByHomebrew' '#{app}/Contents/Info.plist'").strip
  end
end
