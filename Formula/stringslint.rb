class Stringslint < Formula
  desc "Ensure localized strings are complete and never unused"
  homepage "https://github.com/dral3x/StringsLint"
  url "https://github.com/dral3x/StringsLint.git",
      :tag      => "0.1.7",
      :revision => "9d6bc6fbad81df32255bf057d67680d2cd689bd4"

  depends_on :xcode => ["14.0", :build]
  depends_on :xcode => "10.2"

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release", "--product", "stringslint"
    bin.install ".build/release/stringslint"
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
