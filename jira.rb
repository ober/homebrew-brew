class Jira < Formula
  desc "jira command line helper"
  homepage "https://github.com/ober/jira"
  url "https://github.com/ober/jira.git"
  version "0.05"

  depends_on "gerbil-scheme-ober" => :build
  depends_on "openssl@1.1" => :build

  bottle do
    root_url "https://github.com/ober/homebrew-brew/raw/master"
    sha256 "3c076001864161a1a12055c8bd4416fff75dbe58862732aa246164d7b1498ff6" => :mojave
  end

  def install
    openssl = Formula["openssl@1.1"]
    ENV.prepend "LDFLAGS", "-L#{openssl.opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{openssl.opt_include}"

    gambit = Formula["gambit-scheme-ober"]
    ENV.append_path "PATH", gambit.opt_bin
    ENV.append_path "PATH", "#{Formula['gambit-scheme-ober'].bin}"
    ENV.append_path "PATH", "#{Formula['gerbil-scheme-ober'].bin}"
    ENV.append_path "PATH", "/usr/local/opt/gambit-scheme-ober/current/bin"
    ENV['GERBIL_HOME'] = "/usr/local/opt/gerbil-scheme-ober/libexec"
    ENV['CC'] =  Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")
    puts ENV['PATH']
    system "./build.ss static"

    bin.install Dir["./jira"]
  end

  plist_options :manual => "docs go here or something"

  test do
    output = `#{bin}/jira`
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
