class Jira < Formula
  desc "jira command line helper"
  homepage "https://github.com/ober/jira"
  url "https://github.com/ober/jira.git"
  version "master"

  depends_on "gerbil-scheme"

  def install

    openssl = Formula["openssl"]
    ENV.prepend "LDFLAGS", "-L#{openssl.opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{openssl.opt_include}"

    gambit = Formula["gambit-scheme"]
    ENV.append_path "PATH", gambit.opt_bin
    puts "XXX: #{Formula['gambit-scheme'].bin}"
    puts "XXX: #{Formula['gambit-scheme'].opt_bin}"
    ENV.append_path "PATH", "#{Formula['gambit-scheme'].bin}"
    ENV.append_path "PATH", "#{Formula['gerbil-scheme'].bin}"

    system "./build.ss static"

    bin.install Dir["./jira"]
  end

  test do
    output = `#{bin}/jira`
    assert_equal 0, $CHILD_STATUS.exitstatus
  end


end
