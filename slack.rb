class Slack < Formula
  desc "Slack command line helper"
  homepage "https://github.com/ober/slack"
  url "https://github.com/ober/slack.git"
  version "master"

  depends_on "gerbil-scheme-ssl" => :build

  bottle do
    root_url "https://github.com/ober/homebrew-brew/raw/master"
    sha256 "0723c8d1727f81318eda7a986f7ecf8905521e1a4fadd84dc3fbf41b1d09930e" => :mojave
  end

  def install
    openssl = Formula["openssl"]
    ENV.prepend "LDFLAGS", "-L#{openssl.opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{openssl.opt_include}"

    leveldb = Formula["leveldb"]
    ENV.prepend "LDFLAGS", "-L#{leveldb.opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{leveldb.opt_include}"

    ENV.append_path "PATH", "#{Formula['gambit-scheme-ssl'].bin}"
    ENV.append_path "PATH", "#{Formula['gerbil-scheme-ssl'].bin}"
    ENV.append_path "PATH", "/usr/local/opt/gambit-scheme-ssl/current/bin"
    ENV['GERBIL_HOME'] = "/usr/local/opt/gerbil-scheme-ssl/libexec"
    ENV['CC'] =  Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")
    system "./build.ss static"

    bin.install Dir["./slack"]
  end

  test do
    output = `#{bin}/slack`
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
