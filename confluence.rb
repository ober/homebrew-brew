class Confluence < Formula
  desc "confluence command line helper"
  homepage "https://github.com/ober/confluence"
  url "https://github.com/ober/confluence.git"
  version "master"

  depends_on "gerbil-scheme-ssl"

  bottle do
    root_url "https://github.com/ober/homebrew-brew/raw/master"
    sha256 "ea8bd1cc1a3449501829ac4edd17f8d780cbe72aed529fc93d973976bb72a4f1" => :mojave
  end

  def install
    openssl = Formula["openssl"]
    ENV.prepend "CPPFLAGS", "-I#{Formula['openssl'].opt_include}"
    ENV.prepend "LDFLAGS", "-L#{Formula['openssl'].opt_lib}"

    ENV.append_path "PATH", "#{Formula['gambit-scheme-ssl'].bin}"
    ENV.append_path "PATH", "#{Formula['gerbil-scheme-ssl'].bin}"
    ENV['GERBIL_HOME'] = "/usr/local/opt/gerbil-scheme-ssl/libexec"
    ENV.append_path "PATH", "/usr/local/opt/gambit-scheme-ssl/current/bin"
    ENV['CC'] =  Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")
    system "./build.ss static"
    bin.install Dir["./confluence"]
  end

  test do
    output = `#{bin}/confluence`
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
