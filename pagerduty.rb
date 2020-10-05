class Pagerduty < Formula
  desc "Pagerduty command line helper"
  homepage "https://github.com/ober/datadog"
  url "https://github.com/ober/datadog.git"
  version "0.07"

  depends_on "gerbil-scheme-ober" => :build

  bottle do
    root_url "https://github.com/ober/homebrew-artifacts/raw/master"
    sha256 "57eaed33c38aab51d0f6462868ab0f01d5ecacdf6fad2e1c8c05d3b94524ad54" => :mojave
  end

  def install
    #ENV['CC'] = Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")
    gxpkg_dir = Dir.mktmpdir

    gambit = Formula["gambit-scheme-ober"]
    ENV.append_path "PATH", "#{gambit.opt_prefix}/current/bin"

    gerbil = Formula["gerbil-scheme-ober"]
    ENV['GERBIL_HOME'] = "#{gerbil}"

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
