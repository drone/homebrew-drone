require "formula"

class AbstractDrone < Formula
  def self.init
    homepage "https://github.com/harness/drone-cli"
    head "https://github.com/harness/drone-cli.git"
    url artifact_url
    sha256 sha256sum

    test do
      system "#{bin}/drone", "--version"
    end
  end

  def self.curl_cmd
    c = 'curl -L -s'
    if ENV['HOMEBREW_GITHUB_API_TOKEN']
      c += " -H 'Authorization: token #{ENV['HOMEBREW_GITHUB_API_TOKEN']}'"
    end
    c
  end

  def self.get(url)
    JSON.parse(`#{curl_cmd} #{url}`)
  end

  def self.artifact_url
    if version.nil?
      version "latest"
    end
    version == "latest" ? latest_url : "https://github.com/harness/drone-cli/releases/download/v#{version}/drone_darwin_amd64.tar.gz"
  end

  def self.latest_url
    assets.select { |v| File.basename(v['browser_download_url']) == download_file }.first['browser_download_url']
  end

  def self.assets
    json = get "https://api.github.com/repos/harness/drone-cli/releases/latest"

    if json['message'] =~ /API rate limit exceeded/
      raise json['message']
    end

    if !json.key?('assets')
      raise "Could not find any assets"
    end

    json['assets']
  end

  def self.sha256sum
    if version.nil?
      version "latest"
    end

    return latest_sha256sum if version == "latest"

    `curl -L -s https://github.com/harness/drone-cli/releases/download/v#{version}/drone_checksums.txt`.split(' ').first
  end

  def self.latest_sha256sum
    checksum_assest = assets.select { |v| File.basename(v['browser_download_url']) == 'drone_checksums.txt' }
    if checksum_assest.empty?
      raise "Could not find checksum"
    end
    url = checksum_assest.first['browser_download_url']
    `curl -L -s #{url}`.lines.grep(/#{download_file}/).first.split(' ').first
  end

  def self.download_file
    return 'drone_linux_amd64.tar.gz' if os == :linux
    'drone_darwin_amd64.tar.gz'
  end

  def self.os
    @os ||= (
      host_os = RbConfig::CONFIG['host_os']
      case host_os
      when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
        :windows
      when /darwin|mac os/
        :macosx
      when /linux/
        :linux
      when /solaris|bsd/
        :unix
      else
        raise Error::WebDriverError, "unknown os: #{host_os.inspect}"
      end
    )
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
