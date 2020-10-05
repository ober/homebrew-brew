class Pagerduty < Formula
  desc "Pagerduty command line helper"
  homepage "https://github.com/ober/datadog"
  url "https://github.com/ober/datadog.git"
  version "0.07"

  depends_on "gerbil-scheme-ober" => :build

  bottle do
    root_url "https://github.com/ober/homebrew-artifacts/raw/master"
    sha256 "0b60d3c3eb0638a8b1f6a04333f0100f3ccc3cc199e2e8968c52aa5a12468115" => :catalina
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
