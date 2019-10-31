class Jira < Formula
  desc "jira command line helper"
  homepage "https://github.com/ober/jira"
  url "https://github.com/ober/jira.git"
  version "0.05"
  depends_on "gerbil-scheme-ober"

  bottle do
    cellar :any_skip_relocation
    root_url "https://github.com/ober/homebrew-brew/raw/master"
    sha256 "240764928e77c80b669ea6ca19fd8c9575c9c7f4d19d86c42d514f346f562451" => :catalina
    sha256 "d2980b5be4b6fbff8667c2ad17c7ad4e8ac6048382cbd2349e8a3e3d375fa059" => :mojave
  end

  def install
    ENV['CC'] = Formula['gcc'].opt_bin/Formula['gcc'].aliases.first.gsub("@","-")

    gambit = Formula["gambit-scheme-ober"]
    ENV.append_path "PATH", "#{gambit.opt_prefix}/current/bin"

    gerbil = Formula["gerbil-scheme-ober"]
    ENV['GERBIL_HOME'] = "#{gerbil.libexec}"

    ENV['GERBIL_PATH'] = "/tmp/gerbil"

    mkdir_p bin # hack to get around bug in gxpkg
    mkdir_p "#{prefix}/pkg" # ditto
    system "gxpkg", "install", "github.com/ober/jira"
    bin.install Dir["/tmp/gerbil/bin"]
  end

  plist_options :manual => "docs go here or something"

  test do
    output = `#{bin}/jira`
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
