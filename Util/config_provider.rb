require 'yaml'

class ConfigProvider
  CONFIG_DIR = File.join(File.dirname(__FILE__), "..", "configs")

  def initialize(name)
    @config_data = YAML.load_file(File.join(CONFIG_DIR, "#{name.downcase}.yaml"))
  end
  
  def version
    @config_data["version"]
  end
  
  def sha256_darwin_amd64
    @config_data["sha256"]["darwin"]["amd64"]
  end

  def sha256_darwin_arm64
    @config_data["sha256"]["darwin"]["arm64"]
  end

  def sha256_linux_amd64
    @config_data["sha256"]["linux"]["amd64"]
  end

  def sha256_linux_arm64
    @config_data["sha256"]["linux"]["arm64"]
  end
end
