# typed: false
# frozen_string_literal: true

class Confluence < Formula
  desc "Command-line helper"
  homepage "https://github.com/ober/confluence"
  url "https://github.com/ober/confluence.git"

  version "0.13"
  bottle do
    root_url "https://github.com/ober/homebrew-artifacts/raw/master"
    sha256 catalina: "34477dd2d788dec757c6882db06ba40331bea0e3ba5d1b3f8afc09855f89f780"
  end

  depends_on "gerbil-scheme-ober" => :build

  def install
    # ENV['CC'] = Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")
    gxpkg_dir = Dir.mktmpdir

    gambit = Formula["gambit-scheme-ober"]
    ENV.append_path "PATH", "#{gambit.opt_prefix}/current/bin"

    gerbil = Formula["gerbil-scheme-ober"]
    ENV["GERBIL_HOME"] = gerbil.opt_prefix.to_s

    ENV["GERBIL_PATH"] = gxpkg_dir
    mkdir_p "#{gxpkg_dir}/bin" # HACK: to get around gerbil not making ~/.gxpkg/bin
    mkdir_p "#{gxpkg_dir}/pkg" # ditto
    system "gxpkg", "install", "github.com/ober/confluence"
    bin.install Dir["#{gxpkg_dir}/bin/confluence"]
  end

  test do
    output = `#{bin}/confluence`
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
