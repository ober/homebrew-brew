class Pagerduty < Formula
  desc "Pagerduty command line helper"
  homepage "https://github.com/ober/datadog"
  url "https://github.com/ober/datadog.git"
  version "0.09"

  depends_on "gerbil-scheme-ober" => :build

  bottle do
    root_url "https://github.com/ober/homebrew-artifacts/raw/master"
    sha256 "eb275abfabdeff041154a1c0d8eaadf07acdc2bbf48f63ae0034cae8477cb5d8" => :catalina
  end

  def install
    #ENV['CC'] = Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")
    gxpkg_dir = Dir.mktmpdir

    gambit = Formula["gambit-scheme-ober"]
    ENV.append_path "PATH", "#{gambit.opt_prefix}/current/bin"

    gerbil = Formula["gerbil-scheme-ober"]
    ENV['GERBIL_HOME'] = "#{gerbil.opt_prefix}"

    ENV['GERBIL_PATH'] = gxpkg_dir
    mkdir_p "#{gxpkg_dir}/bin" # hack to get around gerbil not making ~/.gxpkg/bin
    mkdir_p "#{gxpkg_dir}/pkg" # ditto
    system "gxpkg", "install", "github.com/ober/pagerduty"
    bin.install Dir["#{gxpkg_dir}/bin/pagerduty"]
  end

  test do
    output = `#{bin}/pagerduty`
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
