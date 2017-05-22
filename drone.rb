require "formula"
require "securerandom"

class Drone < Formula
  homepage "https://github.com/drone/drone"
  head "https://github.com/drone/drone.git"
  url "https://github.com/drone/drone-cli/releases/download/v0.6.0/drone_darwin_amd64.tar.gz"
  sha256 "c97670fae9202694efc3f72b409ce818976e9b4f7946d2826faabc6133ba969e"

  bottle :unneeded
  
  def install
    bin.install "#{buildpath}/drone" => "drone"
  end

  test do
    system "#{bin}/drone", "--version"
  end
end
