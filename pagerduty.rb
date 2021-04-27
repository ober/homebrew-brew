# typed: false
# frozen_string_literal: true

class Pagerduty < Formula
  desc "Command-line helper"
  homepage "https://github.com/ober/datadog"
  url "https://github.com/ober/datadog.git"
  version "0.12"

  bottle do
    root_url "https://github.com/ober/homebrew-artifacts/raw/master"
    sha256 catalina: "b98cef387bda20c6aeb4a569a3f4a06b53629845064092825c9f79596e83f3fd"
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
    system "gxpkg", "install", "github.com/ober/pagerduty"
    bin.install Dir["#{gxpkg_dir}/bin/pagerduty"]
  end

  test do
    output = `#{bin}/pagerduty`
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
