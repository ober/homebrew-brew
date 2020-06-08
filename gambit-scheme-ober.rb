class GambitSchemeOber < Formula
  desc "Gambit Scheme is an implementation of the Scheme Language"
  homepage "https://github.com/gambit/gambit"
  url "https://github.com/gambit/gambit/archive/v4.9.3.tar.gz"
  sha256 "a5e4e5c66a99b6039fa7ee3741ac80f3f6c4cff47dc9e0ff1692ae73e13751ca"

  depends_on "openssl@1.1"

  bottle do
    root_url "https://github.com/ober/homebrew-artifacts/raw/master"
    rebuild 9
    sha256 "5db5d4de074d0948947b2cd983c48ca04021c6b702bfe1254bb146048b058c81" => :mojave
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
    assert_equal "0123456789",
      shell_output("#{prefix}/current/bin/gsi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end
