require File.expand_path("../../Abstract/abstract-drone", __FILE__)

class DroneAT081 < AbstractDrone
  init
  url "https://github.com/drone/drone-cli/releases/download/v0.8.1/drone_darwin_amd64.tar.gz"
  sha256 `curl -L -s https://github.com/drone/drone-cli/releases/download/v0.8.1/drone_checksums.txt`.split(' ').first
  version "0.8.1"
end
