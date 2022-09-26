# typed: false
# frozen_string_literal: true
require_relative "../Util/config_provider"

class Rok < Formula
  config_provider = ConfigProvider.new("rok")
  
  desc "rok is the official CLI for Immerok Cloud"
  homepage "https://github.com/immerok"
  version config_provider.version
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://releases.immerok.cloud/rok/v#{version}/rok-darwin-arm64.tar.gz"
      sha256 config_provider.sha256_darwin_arm64
    end
    
    on_intel do
      url "https://releases.immerok.cloud/rok/v#{version}/rok-darwin-amd64.tar.gz"
      sha256 config_provider.sha256_darwin_amd64
    end
  end
  
  on_linux do
    on_arm do
      url "https://releases.immerok.cloud/rok/v#{version}/rok-linux-arm64.tar.gz"
      sha256 config_provider.sha256_linux_arm64
    end
    
    on_intel do
      url "https://releases.immerok.cloud/rok/v#{version}/rok-linux-amd64.tar.gz"
      sha256 config_provider.sha256_linux_amd64
    end
  end

  def install
    bin.install "rok"
    generate_completions_from_executable("#{bin}/rok", "completion")
  end
  
  test do
    system "#{bin}/rok version"
  end
end
