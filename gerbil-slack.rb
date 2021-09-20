# typed: false
# frozen_string_literal: true

class Slack < Formula
  desc "Command-line helper"
  homepage "https://github.com/ober/slack"
  url "https://github.com/ober/slack.git"
  version "0.07"

  bottle do
    root_url "https://github.com/ober/homebrew-artifacts/raw/master"
    sha256 mojave: "ab9017ffe8d8580ecd2d12420fd673c428945889aea2bd42570aa04daad492b0"
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
    system "gxpkg", "install", "github.com/ober/slack"
    bin.install Dir["#{gxpkg_dir}/bin/slack"]
  end

  test do
    output = `#{bin}/slack`
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
