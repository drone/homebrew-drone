require "formula"
require "securerandom"

class Drone < Formula
  homepage "https://github.com/drone/drone"
  head "https://github.com/drone/drone.git"
  url "https://github.com/drone/drone-cli/releases/download/v0.7.0/drone_darwin_amd64.tar.gz"
  sha256 "253f415a55dbc4f01cb8736ab7ce414997f3101cddcb5bcc82b0b050b8a7a69b"

  bottle :unneeded
  
  def install
    bin.install "#{buildpath}/drone" => "drone"
  end

  test do
    system "#{bin}/drone", "--version"
  end
end
