class Slack < Formula
  desc "Slack command line helper"
  homepage "https://github.com/ober/slack"
  url "https://github.com/ober/slack.git"
  version "master"

  depends_on "gerbil-scheme" => "with-leveldb"

  def install
    openssl = Formula["openssl"]
    ENV.prepend "LDFLAGS", "-L#{openssl.opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{openssl.opt_include}"

    leveldb = Formula["leveldb"]
    ENV.prepend "LDFLAGS", "-L#{leveldb.opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{leveldb.opt_include}"

    ENV.append_path "PATH", "#{Formula['gambit-scheme'].bin}"
    ENV.append_path "PATH", "#{Formula['gerbil-scheme'].bin}"

    system "./build.ss static"

    bin.install Dir["./slack"]
  end

  test do
    output = `#{bin}/slack`
    assert_equal 0, $CHILD_STATUS.exitstatus
  end


end
