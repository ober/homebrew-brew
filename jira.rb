class Jira < Formula
  desc "jira command line helper"
  homepage "https://github.com/ober/jira"
  url "https://github.com/ober/jira.git"
  version "master"

  depends_on "gerbil-scheme-ssl" => :build

  bottle do
    root_url "https://github.com/ober/homebrew-brew/raw/master"
    sha256 "040eec70985b7c5c0186c248edddace9d583fefc4c6bd7562306216984f772b2" => :mojave
  end

  def install
    openssl = Formula["openssl"]
    ENV.prepend "LDFLAGS", "-L#{openssl.opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{openssl.opt_include}"

    gambit = Formula["gambit-scheme-ssl"]
    ENV.append_path "PATH", gambit.opt_bin
    ENV.append_path "PATH", "#{Formula['gambit-scheme-ssl'].bin}"
    ENV.append_path "PATH", "#{Formula['gerbil-scheme-ssl'].bin}"
    ENV.append_path "PATH", "/usr/local/opt/gambit-scheme-ssl/current/bin"
    ENV['GERBIL_HOME'] = "/usr/local/opt/gerbil-scheme-ssl/libexec"
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
