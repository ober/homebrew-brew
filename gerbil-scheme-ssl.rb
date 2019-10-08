class GerbilSchemeSsl < Formula
  desc "Opinionated dialect of Scheme designed for Systems Programming"
  homepage "https://cons.io"
  url "https://github.com/vyzo/gerbil/archive/v0.15.1.tar.gz"

  sha256 "3d29eecdaa845b073bf8413cd54e420b3f48c79c25e43fab5a379dde029d0cde"

  bottle do
    root_url "https://github.com/ober/homebrew-brew/raw/master"
    sha256 "97e715fb272ae3ba151608c65dd38509e0336db9011a2cd707c0f50e8ccf415d" => :mojave
  end

  depends_on "gambit-scheme-ssl"
  depends_on "leveldb"
  depends_on "gcc"
  depends_on "libyaml"
  depends_on "lmdb"
  depends_on "openssl"

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

      inreplace "src/bootstrap/gerbil/gambit/os.ssi" do |s|
        s.gsub! "(tty-mode-set! tty-mode-set!)","(tty-mode-reset tty-mode-reset)(tty-mode-set! tty-mode-set!)"
      end

      ENV.prepend "CPPFLAGS", "-I#{Formula["libyaml"].opt_include}"
      ENV.prepend "CPPFLAGS", "-I#{Formula["leveldb"].opt_include}"
      ENV.prepend "CPPFLAGS", "-I#{Formula["lmdb"].opt_include}"
      ENV.prepend "CPPFLAGS", "-I#{Formula["openssl"].opt_include}"
      ENV.prepend "LDFLAGS", "-L#{Formula["libyaml"].opt_lib}"
      ENV.prepend "LDFLAGS", "-L#{Formula["lmdb"].opt_lib}"
      ENV.prepend "LDFLAGS", "-L#{Formula["leveldb"].opt_lib}"
      ENV.prepend "LDFLAGS", "-L#{Formula["openssl"].opt_lib}"

      ENV['CC'] =  Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")
      ENV.append_path "PATH", "#{Formula["gambit-scheme-ssl"].opt_prefix}/current/bin"

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
