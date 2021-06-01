# typed: false
# frozen_string_literal: true

class GambitSchemeCurrent < Formula
  desc "Gambit Scheme is an implementation of the Scheme Language"
  homepage "http://gambitscheme.org"
  head "https://github.com/gambit/gambit.git", revision: "b3455576"

  depends_on "openssl@1.1"
  # depends_on "gcc" => :build

  def install
    args = %W[
    --enable-default-runtime-options=f8,-8,t8
    --enable-openssl
    --enable-multiple-versions
    --enable-smp
    --prefix=#{prefix}
    ]

# --enable-single-host

    # inreplace "lib/os_io.c" do |s|
    #   s.gsub! 'SSL_VERIFY_PEER', 'SSL_VERIFY_NONE'
    # end
    # ENV['CC'] = "#{Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")}"

    system "./configure", *args
    system "make", "bootstrap"
    system "make", "bootclean"
    system "make", "-j4"
    system "make", "modules"
    system "make", "install"
  end

  test do
    assert_equal "0123456789", shell_output("#{prefix}/v4.9.3/bin/gsi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end
