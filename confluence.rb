class Confluence < Formula
  desc "confluence command line helper"
  homepage "https://github.com/ober/confluence"
  url "https://github.com/ober/confluence.git"

  depends_on "gerbil-scheme-ober" => :build
  version "0.02"

  bottle do
    root_url "https://github.com/ober/homebrew-brew/raw/master"
    sha256 "2dcf8d1a521306298f70407a45ef188cf181c34977233739fe93e8d4fca9ea51" => :catalina
    sha256 "2958b62c87a0beee29ab46582527c096d7a668d1db2c6e874b1b42d91346d7b4" => :mojave
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
