class GambitSchemeOber < Formula
  desc "Gambit Scheme is an implementation of the Scheme Language"
  homepage "http://gambitscheme.org"
  url "https://github.com/gambit/gambit/archive/v4.9.3.tar.gz"
  sha256 "a5e4e5c66a99b6039fa7ee3741ac80f3f6c4cff47dc9e0ff1692ae73e13751ca"

  depends_on "openssl@1.1"
  depends_on "texinfo" => :build
  depends_on "zlib" => :build

  bottle do
    root_url "https://github.com/ober/homebrew-artifacts/raw/master"
    rebuild 8
    sha256 "373b6bb8ead8604673408ec6c0579b1612d1058ec3d0bb309f290f082c1add44" => :mojave
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-multiple-versions
      --enable-single-host
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

    # Fixed in gambit HEAD, but they haven't cut a release
    inreplace "config.status" do |s|
      s.gsub! %r{/usr/local/opt/openssl(?!@1\.1)}, "/usr/local/opt/openssl@1.1"
    end
    system "./config.status"

    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_equal "0123456789", shell_output("#{prefix}/current/bin/gsi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end
