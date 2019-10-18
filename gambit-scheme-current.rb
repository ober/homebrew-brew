class GambitSchemeCurrent < Formula
  desc "Gambit Scheme is an implementation of the Scheme Language"
  homepage "http://gambitscheme.org"
  head "https://github.com/gambit/gambit.git"

  depends_on "openssl" => :build
  depends_on "gcc" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      # --enable-single-host
      # --enable-multiple-versions
      # --enable-default-runtime-options=f8,-8,t8
      # --enable-openssl
    ]

    # inreplace "lib/os_io.c" do |s|
    #   s.gsub! 'SSL_VERIFY_PEER', 'SSL_VERIFY_NONE'
    # end

    ENV['CC'] = "#{Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")}" # -D___USE_C_RTS_CHAR_OPERATIONS"
    openssl = Formula["openssl"]
    ENV.prepend "LDFLAGS", "-L#{openssl.opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{openssl.opt_include}"
    system "./configure", *args
    ENV.deparallelize
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "0123456789", shell_output("#{prefix}/v4.9.1/bin/gsi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end
