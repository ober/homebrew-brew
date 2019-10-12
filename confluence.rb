class Confluence < Formula
  desc "confluence command line helper"
  homepage "https://github.com/ober/confluence"
  url "https://github.com/ober/confluence.git"
  version "master"

  depends_on "gerbil-scheme-ober" => :build

  bottle do
    root_url "https://github.com/ober/homebrew-brew/raw/master"
    sha256 "4fa2cd1ab5e1c105df89ed771d65e7e1ab572e4e6672b7a332a1701a112273b1" => :mojave
  end

  def install
    openssl = Formula["openssl"]
    ENV.prepend "CPPFLAGS", "-I#{Formula['openssl'].opt_include}"
    ENV.prepend "LDFLAGS", "-L#{Formula['openssl'].opt_lib}"
    ENV.append_path "PATH", "#{Formula['gambit-scheme-ober'].bin}"
    ENV.append_path "PATH", "#{Formula['gerbil-scheme-ober'].bin}"
    ENV['GERBIL_HOME'] = "/usr/local/opt/gerbil-scheme-ober/libexec"
    ENV.append_path "PATH", "/usr/local/opt/gambit-scheme-ober/current/bin"
    ENV['CC'] =  Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")
    system "./build.ss static"
    bin.install Dir["./confluence"]
  end

  test do
    output = `#{bin}/confluence`
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
