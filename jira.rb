# typed: false
# frozen_string_literal: true

class Jira < Formula
  desc "Command-line helper"
  homepage "https://github.com/ober/jira"
  url "https://github.com/ober/jira.git"

  version "0.21"
  bottle do
    root_url "https://github.com/ober/homebrew-artifacts/raw/master"
    sha256 catalina: "0c27a238aa4bca6814a7d232598fc2ef595053a339af1c0357beaefb7a24f49e"
  end

  depends_on "gerbil-scheme-ober"

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
    system "gxpkg", "install", "github.com/ober/jira"
    bin.install Dir["#{gxpkg_dir}/bin/jira"]
  end

  plist_options manual: "docs go here or something"

  test do
    output = `#{bin}/jira`
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
