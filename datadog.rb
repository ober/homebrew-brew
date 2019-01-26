class Datadog < Formula
  desc "Datadog command line helper"
  homepage "https://github.com/ober/datadog"
  url "https://github.com/ober/datadog.git"
  version "master"

  depends_on "gerbil-scheme-ssl"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-brew"
    cellar :any
    sha256 "cebe7fa83bf424c1201d6c395c9a8d59d34ddebb1f43f942f1b09c859fab72f1" => :mojave
  end

  def install
    openssl = Formula["openssl"]
    ENV.prepend "LDFLAGS", "-L#{openssl.opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{openssl.opt_include}"
    ENV.append_path "PATH", "#{Formula['gerbil-scheme-ssl'].bin}"
    ENV.append_path "PATH", "/usr/local/opt/gambit-scheme-ssl/current/bin"
    ENV['GERBIL_HOME'] = "/usr/local/opt/gerbil-scheme-ssl/libexec"
    ENV['CC'] =  Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")
    system "./build.ss static"

    bin.install "datadog"
    bin.install_symlink "datadog" => "dda"
  end

  test do
    output = `#{bin}/datadog`
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
