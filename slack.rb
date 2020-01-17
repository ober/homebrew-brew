class Slack < Formula
  desc "Slack command line helper"
  homepage "https://github.com/ober/slack"
  url "https://github.com/ober/slack.git"
  version "0.06"

  bottle do
    root_url "https://github.com/ober/homebrew-artifacts/raw/master"
    sha256 "670974d34f99f8332850c21a30a7f342afcb3aee9982f20f8e4ed2c25991ff01" => :mojave
  end

  depends_on "gerbil-scheme-ober" => :build

  def install
    ENV['CC'] = Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")
    gxpkg_dir = Dir.mktmpdir

    gambit = Formula["gambit-scheme-ober"]
    ENV.append_path "PATH", "#{gambit.opt_prefix}/current/bin"

    gerbil = Formula["gerbil-scheme-ober"]
    ENV['GERBIL_HOME'] = "#{gerbil.libexec}"

    ENV['GERBIL_PATH'] = gxpkg_dir
    mkdir_p "#{gxpkg_dir}/bin" # hack to get around gerbil not making ~/.gxpkg/bin
    mkdir_p "#{gxpkg_dir}/pkg" # ditto
    system "gxpkg", "install", "github.com/ober/slack"
    bin.install Dir["#{gxpkg_dir}/bin/slack"]
  end

  test do
    output = `#{bin}/slack`
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
