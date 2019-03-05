class Datadog < Formula
  desc "Datadog command line helper"
  homepage "https://github.com/ober/datadog"
  url "https://github.com/ober/datadog.git"
  version "master"

  depends_on "gerbil-scheme-ssl" => :build

  bottle do
    root_url "https://github.com/ober/homebrew-brew/raw/master/"
    sha256 "38c720f12e87a879d803d091ddfac8b39c55ee5d0e8026dbbc965fb3bfe4d4d5  datadog-master.mojave.bottle.tar.gz" => :mojave
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
