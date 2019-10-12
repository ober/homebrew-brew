class GambitSchemeOber < Formula
  desc "Gambit Scheme is an implementation of the Scheme Language"
  homepage "http://gambitscheme.org"
  url "https://github.com/gambit/gambit/archive/v4.9.3.tar.gz"
  sha256 "a5e4e5c66a99b6039fa7ee3741ac80f3f6c4cff47dc9e0ff1692ae73e13751ca"

  depends_on "openssl"
  depends_on "gcc"

  bottle do
    rebuild 1
    root_url "https://github.com/ober/homebrew-brew/raw/master"
    sha256 "8ea5f8bd64fbdb9ab917f2a8924efaafa6cc1d13e0aad4cce39cd8cfa14ab0ae" => :mojave
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-single-host
      --enable-multiple-versions
      --enable-default-runtime-options=f8,-8,t8
      --enable-openssl
    ]

    ENV['CC'] =  Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")
    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_equal "0123456789", shell_output("#{prefix}/current/bin/gsi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end
