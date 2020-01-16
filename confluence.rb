class Confluence < Formula
  desc "confluence command line helper"
  homepage "https://github.com/ober/confluence"
  url "https://github.com/ober/confluence.git"

  depends_on "gerbil-scheme-ober" => :build
  version "0.07"

  bottle do
    root_url "https://github.com/ober/homebrew-brew/raw/master"
    rebuild 2
    sha256 "bff53007921e3d50494624e2f28885216a4bca360d6252c9caac073e70471636" => :mojave
  end

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
    system "gxpkg", "install", "github.com/ober/confluence"
    bin.install Dir["#{gxpkg_dir}/bin/confluence"]
  end

  test do
    output = `#{bin}/confluence`
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
