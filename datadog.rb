# typed: false
# frozen_string_literal: true

class Datadog < Formula
  desc "Command-line helper"
  homepage "https://github.com/ober/datadog"
  url "https://github.com/ober/datadog.git"
  version "0.15"

  bottle do
    root_url "https://github.com/ober/homebrew-artifacts/raw/master"
    sha256 mojave: "d56f58041eb8a9eb8b947169732032eb6e6122e376a36f32dda4dc3b2c08ca64"
  end

  depends_on "gerbil-scheme" => :build

  def install
    # ENV['CC'] = Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")
    gxpkg_dir = Dir.mktmpdir

    gambit = Formula["gambit-scheme"]
    ENV.append_path "PATH", "#{gambit.opt_prefix}/current/bin"

    gerbil = Formula["gerbil-scheme"]
    ENV["GERBIL_HOME"] = gerbil.opt_prefix.to_s

    ENV["GERBIL_PATH"] = gxpkg_dir
    mkdir_p "#{gxpkg_dir}/bin" # HACK: to get around gerbil not making ~/.gxpkg/bin
    mkdir_p "#{gxpkg_dir}/pkg" # ditto
    system "gxpkg", "install", "github.com/ober/datadog"
    bin.install Dir["#{gxpkg_dir}/bin/dda"]
  end

  test do
    output = `#{bin}/dda`
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
