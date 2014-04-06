module AresMUSH
  class ConfigReader
    @@config = {}
    
    def initialize
      clear_config
    end

    def self.config
      @@config
    end
    
    def self.config_path
      File.join(AresMUSH.game_path, "config") 
    end

    def self.config_files
      Dir[File.join(ConfigReader.config_path, "**")]
    end

    def config
      @@config
    end
    
    def clear_config
      @@config = {}
    end

    def read
      plugin_config = PluginManager.config_files
      @@config = YamlFileParser.read(ConfigReader.config_files, {} )
      @@config = YamlFileParser.read(plugin_config, @@config)
    end    
  end
end