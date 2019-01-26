class Confluence < Formula
  desc "confluence command line helper"
  homepage "https://github.com/ober/confluence"
  url "https://github.com/ober/confluence.git"
  version "master"

  depends_on "gerbil-scheme-ssl"

  def install
    openssl = Formula["openssl"]
    ENV.prepend "CPPFLAGS", "-I#{Formula['openssl'].opt_include}"
    ENV.prepend "LDFLAGS", "-L#{Formula['openssl'].opt_lib}"

    ENV.append_path "PATH", "#{Formula['gambit-scheme-ssl'].bin}"
    ENV.append_path "PATH", "#{Formula['gerbil-scheme-ssl'].bin}"

    ENV['CC'] =  Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")
    system "./build.ss static"
    bin.install Dir["./confluence"]
  end

  test do
    output = `#{bin}/confluence`
    assert_equal 0, $CHILD_STATUS.exitstatus
  end


end
