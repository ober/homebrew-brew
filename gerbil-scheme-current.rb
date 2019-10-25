class GerbilSchemeCurrent < Formula
  desc "Opinionated dialect of Scheme designed for Systems Programming"
  homepage "https://cons.io"
  head "https://github.com/vyzo/gerbil.git"

  depends_on "gambit-scheme"
  depends_on "leveldb"
  depends_on "libyaml"
  depends_on "gcc"
  depends_on "lmdb"
  depends_on "openssl@1.1"

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
      system "git fetch --tags --force"
      ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version <= :sierra

      inreplace "std/build-features.ss" do |s|
        s.gsub! "(enable leveldb #f)", "(enable leveldb #t)"
        s.gsub! "(enable libxml #f)", "(enable libxml #t)"
        s.gsub! "(enable libyaml #f)", "(enable libyaml #t)"
        s.gsub! "(enable lmdb #f)", "(enable lmdb #t)"
      end

      ENV['CC'] = Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")

      openssl = Formula["openssl@1.1"]
      ENV.prepend "LDFLAGS", "-L#{openssl.opt_lib} -lssl"
      ENV.prepend "CPPFLAGS", "-I#{openssl.opt_include}"

      yaml = Formula["libyaml"]
      ENV.prepend "LDFLAGS", "-L#{yaml.opt_lib}"
      ENV.prepend "CPPFLAGS", "-I#{yaml.opt_include}"

      leveldb = Formula["leveldb"]
      ENV.prepend "LDFLAGS", "-L#{leveldb.opt_lib}"
      ENV.prepend "CPPFLAGS", "-I#{leveldb.opt_include}"

      lmdb = Formula["lmdb"]
      ENV.prepend "LDFLAGS", "-L#{lmdb.opt_lib}"
      ENV.prepend "CPPFLAGS", "-I#{lmdb.opt_include}"

      ENV.append_path "PATH", "#{Formula["gambit-scheme"].opt_prefix}/current/bin"

      system "./build.sh"
    end

    libexec.install "bin", "lib", "doc"

    bins.each do |b|
      bin.install_symlink libexec/"bin/#{b}"
    end
  end

  test do
    ENV.append_path "PATH", "#{Formula["gerbil-scheme-current"].opt_prefix}/current/bin"
    assert_equal "0123456789", shell_output("#{libexec}/bin/gxi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end
