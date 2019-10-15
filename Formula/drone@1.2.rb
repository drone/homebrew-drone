require File.expand_path("../../Abstract/abstract-drone", __FILE__)

class DroneAT12 < AbstractDrone
  version "1.2"
  init
  url "https://github.com/drone/drone-cli/releases/download/v1.2.0/drone_darwin_amd64.tar.gz"
  sha256 `curl -L -s https://github.com/drone/drone-cli/releases/download/v1.2.0/drone_checksums.txt`.split(' ').first
end
