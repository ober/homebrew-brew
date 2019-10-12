class Slack < Formula
  desc "Slack command line helper"
  homepage "https://github.com/ober/slack"
  url "https://github.com/ober/slack.git"
  version "0.02"

  depends_on "gerbil-scheme-ober" => :build
  depends_on "gnu-sed" => :build
#XXX needed for openssl to be found: ln -s /usr/local/opt/openssl@1.1/include/openssl /usr/local/include


  bottle do
    root_url "https://github.com/ober/homebrew-brew/raw/master"
    sha256 "b4e664e4b02fc5d5ed55fd2f263ca1a95d31b70b16c8ff0a604e3e3a91ed4582" => :mojave
  end

  def install
    openssl = Formula["openssl@1.1"]
    ENV.prepend "LDFLAGS", "-L#{openssl.opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{openssl.opt_include}"
    puts "here #{openssl.opt_include}"
    leveldb = Formula["leveldb"]
    ENV.prepend "LDFLAGS", "-L#{leveldb.opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{leveldb.opt_include}"

    ENV.append_path "PATH", "#{Formula['gambit-scheme-ober'].bin}"
    ENV.append_path "PATH", "#{Formula['gerbil-scheme-ober'].bin}"
    ENV.append_path "PATH", "/usr/local/opt/gambit-scheme-ober/current/bin"
    ENV['GERBIL_HOME'] = "/usr/local/opt/gerbil-scheme-ober/libexec"
    ENV['CC'] =  Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")
    system "./build.ss static"

    bin.install Dir["./slack"]
  end

  test do
    output = `#{bin}/slack`
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
