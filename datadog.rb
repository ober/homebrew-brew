class Datadog < Formula
  desc "Datadog command line helper"
  homepage "https://github.com/ober/datadog"
  url "https://github.com/ober/datadog.git"
  version "0.08"

  depends_on "gerbil-scheme-ober" => :build

  bottle do
    root_url "https://github.com/ober/homebrew-brew/raw/master"
    sha256 "9d782f88d50ccdc3d7eac315b1a4b12bd855b530b251b2686bfd79bdc7b8914e" => :mojave
  end

  def install
    ENV['CC'] = Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")
    gxpkg_dir = Dir.mktmpdir

    gambit = Formula["gambit-scheme-ober"]
    ENV.append_path "PATH", "#{gambit.opt_prefix}/current/bin"

    gerbil = Formula["gerbil-scheme-ober"]
    ENV['GERBIL_HOME'] = "#{gerbil.libexec}"

    ENV['GERBIL_PATH'] = gxpkg_dir
    mkdir_p "#{gxpkg_dir}/bin" # hack to get around gerbil not making ~/.gxpkg/bin
    mkdir_p "#{gxpkg_dir}/pkg" # ditto
    system "gxpkg", "install", "github.com/ober/datadog"
    bin.install Dir["#{gxpkg_dir}/bin/dda"]
  end

  test do
    output = `#{bin}/datadog`
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
