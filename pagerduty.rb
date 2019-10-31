class Pagerduty < Formula
  desc "Pagerduty command line helper"
  homepage "https://github.com/ober/datadog"
  url "https://github.com/ober/datadog.git"
  version "0.02"

  depends_on "gerbil-scheme-ober" => :build

  def install
    ENV['CC'] = Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")

    gambit = Formula["gambit-scheme-ober"]
    ENV.append_path "PATH", "#{gambit.opt_prefix}/current/bin"

    gerbil = Formula["gerbil-scheme-ober"]
    ENV['GERBIL_HOME'] = "#{gerbil.libexec}"

    ENV['GERBIL_PATH'] = prefix

    mkdir_p bin # hack to get around bug in gxpkg
    mkdir_p "#{prefix}/pkg" # ditto
    system "gxpkg", "install", "github.com/ober/pagerduty"
  end

  test do
    output = `#{bin}/pagerduty`
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
