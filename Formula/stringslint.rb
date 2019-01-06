class Stringslint < Formula
  desc "Ensure localized strings are complete and never unused"
  homepage "https://github.com/dral3x/StringsLint"
  url "https://github.com/dral3x/StringsLint.git",
      :tag      => "0.0.1",
      :revision => "4131dcf4a594e893010605bc766760ab40d42698"

  depends_on :xcode => ["10.0", :build]
  depends_on :xcode => "10.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/StringsLint.dst"
  end

  test do
    (testpath/"Test.swift").write 'NSLocalizedString("welcome_a", comment: "")'
    (testpath/"Localizable.strings").write '"welcome_b" = "Hello!";'

    assert_match "Test.swift:1: warning: Missing Violation: Localized string is missing (missing)",
                 shell_output("#{bin}/stringslint lint").chomp

    assert_match version.to_s,
                 shell_output("#{bin}/stringslint version").chomp
  end
end
