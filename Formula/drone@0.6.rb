require File.expand_path("../../Abstract/abstract-drone", __FILE__)

class DroneAT06 < AbstractDrone
  init
  url "https://github.com/drone/drone-cli/releases/download/v0.6.0/drone_darwin_amd64.tar.gz"
  sha256 `curl -L -s https://github.com/drone/drone-cli/releases/download/v0.6.0/drone_checksums.txt`.split(' ').first
  version "0.6"
end
