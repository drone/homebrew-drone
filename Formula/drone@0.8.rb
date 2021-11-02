require File.expand_path("../../Abstract/abstract-drone", __FILE__)

class DroneAT08 < AbstractDrone
  version "0.8"
  init
  url "https://github.com/harness/drone-cli/releases/download/v0.8.6/drone_darwin_amd64.tar.gz"
  sha256 `curl -L -s https://github.com/harness/drone-cli/releases/download/v0.8.6/drone_checksums.txt`.split(' ').first
end
