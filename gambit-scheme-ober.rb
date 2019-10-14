class GambitSchemeOber < Formula
  desc "Gambit Scheme is an implementation of the Scheme Language"
  homepage "http://gambitscheme.org"
  url "https://github.com/gambit/gambit/archive/v4.9.3.tar.gz"
  sha256 "a5e4e5c66a99b6039fa7ee3741ac80f3f6c4cff47dc9e0ff1692ae73e13751ca"

  depends_on "gcc" => :build
  depends_on "openssl" => :build
  depends_on "texinfo" => :build

  bottle do
    rebuild 1
    root_url "https://github.com/ober/homebrew-brew/raw/master"
    sha256 "333461b79ac7a3ced3afb92998e2f27f8a2666a47c4a621837d5ff5b98d1ea2e" => :mojave
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-single-host
      --enable-multiple-versions
      --enable-default-runtime-options=f8,-8,t8
      --enable-openssl
    ]

    ENV['CC'] = Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")
    openssl = Formula["openssl"]
    ENV.prepend "LDFLAGS", "-L#{openssl.opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{openssl.opt_include}"
    system "./configure", *args
    system "make"
    ENV.deparallelize

    system "make", "install"
  end

  test do
    assert_equal "0123456789", shell_output("#{prefix}/current/bin/gsi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end
