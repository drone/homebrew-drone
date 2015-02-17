require "formula"
require "securerandom"

class Drone < Formula
  homepage "https://github.com/drone/drone"
  url "http://downloads.drone.io/drone-cli/drone_darwin_amd64.tar.gz"
  sha256 `curl -s http://downloads.drone.io/drone-cli/drone_darwin_amd64.sha256`.split(' ').first

  head do
    url "https://github.com/drone/drone-cli.git", :branch => "master"

    depends_on "go" => :build
    depends_on "mercurial" => :build
    depends_on "bzr" => :build
    depends_on "git" => :build
  end

  def install
    if build.head?
      drone_build_home = "/tmp/#{SecureRandom.hex}"
      drone_build_path = File.join(drone_build_home, "src", "github.com", "drone", "drone-cli")

      ENV["GOPATH"] = drone_build_home
      ENV["GOHOME"] = drone_build_home

      mkdir_p drone_build_path

      system("cp -R #{buildpath}/* #{drone_build_path}")
      ln_s File.join(cached_download, '.git'), File.join(drone_build_path, '.git')

      Dir.chdir drone_build_path

      system("go get ./...")
      system("go build -o ./drone_cli github.com/drone/drone-cli/drone")

      bin.install "#{drone_build_path}/drone_cli" => "drone"
      Dir.chdir buildpath
    else 
      bin.install "#{buildpath}/darwin/amd64/drone" => "drone"
    end
  ensure
    rm_rf drone_build_home if build.head?
  end

  test do
    system "#{bin}/drone", "--version"
  end
end
