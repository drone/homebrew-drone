require "formula"
require "securerandom"

class Drone < Formula
  homepage "https://github.com/drone/drone"
  head "https://github.com/drone/drone.git"

  stable do
    url "http://downloads.drone.io/drone-cli/drone_darwin_amd64.tar.gz"
    sha256 `curl -s http://downloads.drone.io/drone-cli/drone_darwin_amd64.sha256`.split(' ').first
    version "0.4-cli"
  end

  devel do
    url "http://downloads.drone.io/release/darwin/amd64/drone.tar.gz"
    sha256 `curl -s http://downloads.drone.io/release/darwin/amd64/drone.sha256`.split(' ').first
    version "0.5"
  end

  head do
    url "https://github.com/drone/drone.git", :branch => "master"

    depends_on "go" => :build
    depends_on "mercurial" => :build
    depends_on "bzr" => :build
    depends_on "git" => :build
  end

  def install
    if build.head?
      mkdir_p buildpath/File.join("src", "github.com", "drone")
      ln_s buildpath, buildpath/File.join("src", "github.com", "drone", "drone")

      ENV["DRONE_BUILD_NUMBER"] = "homebrew"
      ENV["GOVENDOREXPERIMENT"] = "1"
      ENV["GOPATH"] = buildpath
      ENV["GOHOME"] = buildpath
      ENV["PATH"] += ":" + File.join(buildpath, "bin")

      system("make deps_backend")
      system("make deps gen")
      system("make build_static")

      bin.install "#{buildpath}/release/drone" => "drone"
    else 
      bin.install "#{buildpath}/drone" => "drone"
    end
  end

  test do
    system "#{bin}/drone", "--version"
  end
end
