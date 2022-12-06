require File.expand_path("../../Abstract/abstract-drone", __FILE__)

class DroneAT16 < AbstractDrone
  version "1.6"
  init
  url "https://github.com/harness/drone-cli/releases/download/v1.6.0/drone_darwin_amd64.tar.gz"
  sha256 `curl -L -s https://github.com/harness/drone-cli/releases/download/v1.6.0/drone_checksums.txt`.split(' ').first
end
