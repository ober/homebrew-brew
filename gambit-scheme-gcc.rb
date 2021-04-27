# typed: false
# frozen_string_literal: true

class GambitSchemeGcc < Formula
  desc "Gambit Scheme is an implementation of the Scheme Language"
  homepage "https://github.com/gambit/gambit"
  url "https://github.com/gambit/gambit/archive/v4.9.3.tar.gz"
  sha256 "a5e4e5c66a99b6039fa7ee3741ac80f3f6c4cff47dc9e0ff1692ae73e13751ca"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 catalina:    "cc4d0841423822b27fd424f7eba3a0482f01266ef61c25ec4b1d49d211d6c50e"
    sha256 mojave:      "9fc086d950cb20c99d1d24947a0599fab72525c8a2dbd2d448f94791a5a8f481"
    sha256 high_sierra: "8af81a5c228d029402bc150331cb03dc0695eeee8dd5a58ce497a7a49a19fa47"
  end

  depends_on "gcc"
  depends_on "openssl@1.1"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-single-host
      --enable-multiple-versions
      --enable-default-runtime-options=f8,-8,t8
      --enable-openssl
    ]

    system "./configure", *args

    # Fixed in gambit HEAD, but they haven't cut a release
    inreplace "config.status" do |s|
      s.gsub! %r{/usr/local/opt/openssl(?!@1\.1)}, "/usr/local/opt/openssl@1.1"
    end
    ENV["CC"] = Formula["gcc"].opt_bin/Formula["gcc"].aliases.first.tr("@", "-")
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
