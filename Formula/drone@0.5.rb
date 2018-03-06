require File.expand_path("../../Abstract/abstract-drone", __FILE__)

class DroneAT05 < AbstractDrone
  version "0.5"
  init
  url "http://downloads.drone.io/0.5.0/release/darwin/amd64/drone.tar.gz"
  sha256 `curl -s http://downloads.drone.io/0.5.0/release/darwin/amd64/drone.sha256`.split(' ').first
end
