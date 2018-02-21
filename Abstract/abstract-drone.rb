require "formula"

class AbstractDrone < Formula
  def self.init
    homepage "https://github.com/drone/drone-cli"
    head "https://github.com/drone/drone-cli.git"
    url assets.select { |v| File.basename(v['browser_download_url']) == "#{platform_url}" }.first['browser_download_url']
    sha256 sha256sum

    test do
      system "#{bin}/drone", "--version"
    end
  end

  def self.platform_url
    p = 'drone_darwin_amd64.tar.gz'
    if !RUBY_PLATFORM.downcase.include?('darwin')
      p = 'drone_linux_amd64.tar.gz'
    end
    p
  end

  def self.curl_cmd
    c = 'curl -L -s'
    if ENV['HOMEBREW_GITHUB_API_TOKEN']
      c += " -H 'Authorization: token #{ENV['HOMEBREW_GITHUB_API_TOKEN']}'"
    end
    c
  end

  def self.assets
    json = JSON.parse(`#{curl_cmd} https://api.github.com/repos/drone/drone-cli/releases/latest`)

    if json['message'] =~ /API rate limit exceeded/
      raise json['message']
    end

    if !json.key?('assets')
      raise "Could not find any assets"
    end

    json['assets']
  end

  def self.sha256sum
    checksum_assest = assets.select { |v| File.basename(v['browser_download_url']) == 'drone_checksums.txt' }
    if checksum_assest.empty?
      raise "Could not find checksum"
    end
    url = checksum_assest.first['browser_download_url']
    `curl -L -s #{url}`.lines.grep(/#{platform_url}/).first.split(' ').first
  end

  def install
    if build.head?
      mkdir_p buildpath/File.join("src", "github.com", "drone")
      ln_s buildpath, buildpath/File.join("src", "github.com", "drone", "drone")

      ENV["DRONE_BUILD_NUMBER"] = "homebrew"
      ENV["GOVENDOREXPERIMENT"] = "1"
      ENV["GOPATH"] = buildpath
      ENV["GOHOME"] = buildpath
      ENV["PATH"] += ":" + File.join(buildpath, "bin")

      system("make deps_backend")
      system("make deps gen")
      system("make build_static")

      bin.install "#{buildpath}/release/drone" => "drone"
    else
      bin.install "#{buildpath}/drone" => "drone"
    end
  end
end
