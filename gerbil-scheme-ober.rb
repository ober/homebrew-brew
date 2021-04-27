# typed: false
# frozen_string_literal: true

class GerbilSchemeOber < Formula
  desc "Opinionated dialect of Scheme designed for Systems Programming"
  homepage "https://cons.io"
  url "https://github.com/vyzo/gerbil/archive/v0.16.tar.gz"
  sha256 "1157d4ef60dab6a0f7c4986d5c938391973045093c470a03ffe02266c4d3e119"

  bottle do
    root_url "https://github.com/ober/homebrew-artifacts/raw/master"
    sha256 mojave:   "6d96dd44db93f9b8a427479628029efe443fa212b5716398dbc5846ca850a0e4"
    sha256 catalina: "3f3f27ddc909698b21f50699a4aec9c1ea2722508b30e1df8e7cd8875a7ae4bc"
  end

  depends_on "gambit-scheme-ober"
  depends_on "leveldb"
  depends_on "libyaml"
  depends_on "lmdb"
  depends_on "openssl@1.1"

  def install
    cd "src" do
      ENV.append_path "PATH", "#{Formula["gambit-scheme-ober"].opt_prefix}/current/bin"
      ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version <= :sierra
      system "./configure", "--prefix=#{prefix}",
             "--with-gambit=#{Formula["gambit-scheme-ober"].opt_prefix}/current",
             "--enable-leveldb",
             "--enable-libxml",
             "--enable-libyaml",
             "--enable-lmdb"
      system "./build.sh"
      system "./install"

      rm "#{bin}/.keep"
      mv "#{share}/emacs/site-lisp/gerbil", "#{share}/emacs/site-lisp/gerbil-scheme"
    end
  end

  test do
    assert_equal "0123456789", shell_output("gxi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end
