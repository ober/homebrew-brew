class GambitSchemeOber < Formula
  desc "Gambit Scheme is an implementation of the Scheme Language"
  homepage "http://gambitscheme.org"
  url "https://github.com/gambit/gambit/archive/v4.9.3.tar.gz"
  sha256 "a5e4e5c66a99b6039fa7ee3741ac80f3f6c4cff47dc9e0ff1692ae73e13751ca"

  depends_on "openssl@1.1" => :build
  depends_on "texinfo" => :build
  depends_on "zlib" => :build

  bottle do
    root_url "https://github.com/ober/homebrew-brew/raw/master"
    rebuild 6
    sha256 "693f164d76b4bf7f3020c0591e4d7d5fec98e31f06327c142be7fea14becdbaa" => :mojave
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-multiple-versions
      --enable-default-runtime-options=f8,-8,t8
      --enable-openssl
    ]

    inreplace "lib/os_io.c" do |s|
      s.gsub! 'SSL_VERIFY_PEER', 'SSL_VERIFY_NONE'
    end

    openssl = Formula["openssl@1.1"]
    ENV.prepend "LDFLAGS", "-L#{openssl.opt_lib} -lcrypto -lssl"
    ENV.prepend "CPPFLAGS", "-I#{openssl.opt_include}"

    zlib = Formula["zlib"]
    ENV.prepend "LDFLAGS", "-L#{zlib.opt_lib} -lz"
    ENV.prepend "CPPFLAGS", "-I#{zlib.opt_include}"

    system "./configure", *args
    system "make"
    ENV.deparallelize

    system "make", "install"
  end

  test do
    assert_equal "0123456789", shell_output("#{prefix}/current/bin/gsi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end
