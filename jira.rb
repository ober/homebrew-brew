class Jira < Formula
  desc "jira command line helper"
  homepage "https://github.com/ober/jira"
  url "https://github.com/ober/jira.git"
  version "0.05"
  depends_on "gerbil-scheme-ober"

  def install
    # openssl = Formula["openssl"]
    # ENV.prepend "LDFLAGS", "-L#{openssl.opt_lib} -lssl"
    # ENV.prepend "CPPFLAGS", "-I#{openssl.opt_include}"
    ENV['CC'] = Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")
    gambit = Formula["gambit-scheme-ober"]
    ENV.append_path "PATH", "#{gambit.opt_prefix}/current/bin"
    ENV['GERBIL_PATH'] = prefix
    ENV['GERBIL_HOME'] = "/usr/local/opt/gerbil-scheme-ober/libexec"
    mkdir_p bin
    mkdir_p "#{prefix}/pkg"
    system "gxpkg", "install", "github.com/ober/jira"
  end

  plist_options :manual => "docs go here or something"

  test do
    output = `#{bin}/jira`
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
