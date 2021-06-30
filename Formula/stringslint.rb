class Stringslint < Formula
  desc "Ensure localized strings are complete and never unused"
  homepage "https://github.com/dral3x/StringsLint"
  url "https://github.com/dral3x/StringsLint.git",
      :tag      => "0.1.0",
      :revision => "65e4244c760ae77d81d6e796ed638c394970074a"

  depends_on :xcode => ["10.2", :build]
  depends_on :xcode => "10.2"

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
