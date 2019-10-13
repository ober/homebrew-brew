class GerbilSchemeOber < Formula
  desc "Opinionated dialect of Scheme designed for Systems Programming"
  homepage "https://cons.io"
  url "https://github.com/vyzo/gerbil/archive/v0.15.1.tar.gz"
  sha256 "3d29eecdaa845b073bf8413cd54e420b3f48c79c25e43fab5a379dde029d0cde"

  bottle do
    rebuild 1
    root_url "https://github.com/ober/homebrew-brew/raw/master"
    sha256 "5b9c4898dbb05e08c62571e0dcf0f3aad893e7c15ee6330fd188a66472b1098f" => :mojave
  end

  depends_on "gambit-scheme-ober"
  depends_on "leveldb"
  depends_on "gcc"
  depends_on "libyaml"
  depends_on "lmdb"
  depends_on "openssl@1.1"

  patch :p1 do
    url "https://raw.githubusercontent.com/ober/homebrew-brew/master/tty-reset.patch"
    sha256 "195d07e19eeed95dc20aa73a1e897f3c282ef57809e3d4845f6fbbfd562ad408"
  end

  def install
    bins = %w[
      gxi
      gxc
      gxi-build-script
      gxpkg
      gxprof
      gxtags
    ]

    cd "src" do
      ENV.append_path "PATH", "#{Formula["gambit-scheme"].opt_prefix}/current/bin"
      ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version <= :sierra

      inreplace "std/build-features.ss" do |s|
        s.gsub! "(enable leveldb #f)", "(enable leveldb #t)"
        s.gsub! "(enable libxml #f)", "(enable libxml #t)"
        s.gsub! "(enable libyaml #f)", "(enable libyaml #t)"
        s.gsub! "(enable lmdb #f)", "(enable lmdb #t)"
      end

      inreplace "std/net/request.ss" do |s|
        s.gsub! "(http-request 'POST url headers data [] #f)))", "(http-request 'POST url headers data [] #t)))"
      end

      openssl = Formula["openssl@1.1"]
      ENV.prepend "LDFLAGS", "-L#{openssl.opt_lib}"
      ENV.prepend "CPPFLAGS", "-I#{openssl.opt_include}"
      ENV.prepend "CPPFLAGS", "-I#{Formula["libyaml"].opt_include}"
      ENV.prepend "CPPFLAGS", "-I#{Formula["leveldb"].opt_include}"
      ENV.prepend "CPPFLAGS", "-I#{Formula["lmdb"].opt_include}"
      ENV.prepend "LDFLAGS", "-L#{Formula["libyaml"].opt_lib}"
      ENV.prepend "LDFLAGS", "-L#{Formula["lmdb"].opt_lib}"
      ENV.prepend "LDFLAGS", "-L#{Formula["leveldb"].opt_lib}"

      ENV['CC'] =  Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")
      ENV.append_path "PATH", "#{Formula["gambit-scheme-ober"].opt_prefix}/current/bin"

      system "./build.sh"
    end

    libexec.install "bin", "lib", "doc"

    bins.each do |b|
      bin.install_symlink libexec/"bin/#{b}"
    end
  end

  test do
    ENV.append_path "PATH", "#{Formula["gambit-scheme"].opt_prefix}/current/bin"
    assert_equal "0123456789", shell_output("#{libexec}/bin/gxi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end
