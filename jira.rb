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

    ENV['GERBIL_HOME'] = "#{Formula['gerbil-scheme-ober'].libexec}"
    ENV['CC'] =  Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")
    puts ENV['PATH'], ENV['GERBIL_HOME']
    system "gxpkg install github.com/ober/jira"
    #bin.install Dir["./jira"]
    ENV['GERBIL_PATH'] = "."
    ENV['GERBIL_HOME'] = "/usr/local/opt/gerbil-scheme-ober/libexec"
    ENV['CC'] =  Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")
    system "gxpkg install github.com/ober/jira"
    bin.install Dir["bin/jira"]
  end

  plist_options :manual => "docs go here or something"

  test do
    output = `#{bin}/jira`
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
