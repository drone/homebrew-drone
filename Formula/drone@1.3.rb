require File.expand_path("../../Abstract/abstract-drone", __FILE__)

class DroneAT13 < AbstractDrone
  version "1.3"
  init
  url "https://github.com/drone/drone-cli/releases/download/v1.3.3/drone_darwin_amd64.tar.gz"
  sha256 `curl -L -s https://github.com/drone/drone-cli/releases/download/v1.3.3/drone_checksums.txt`.split(' ').first
end
