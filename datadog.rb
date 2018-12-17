class Datadog < Formula
  desc "Datadog command line helper"
  homepage "https://github.com/ober/datadog"
  url "https://github.com/ober/datadog.git"
  version "master"
  depends_on "gambit-scheme"
  depends_on "gerbil-scheme" => "with-yaml"

  def install
    openssl = Formula["openssl"]
    ENV.prepend "LDFLAGS", "-L#{openssl.opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{openssl.opt_include}"

    ENV.append_path "PATH", "#{Formula['gambit-scheme'].bin}"
    ENV.append_path "PATH", "#{Formula['gerbil-scheme'].bin}"

    system "./build.ss static"

    bin.install Dir["./datadog"]
    bin.install_symlink "datadog" => "dda"
  end

  test do
    output = `#{bin}/datadog`
    assert_equal 0, $CHILD_STATUS.exitstatus
  end


end
