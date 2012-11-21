require 'yaml'

module AresMUSH
  class ConfigReader    
    def initialize
      clear_config
    end

    attr_accessor :config

    def self.config_path
      File.join(AresMUSH.game_dir, "config") 
    end
    
    def self.config_files
      Dir[File.join(ConfigReader.config_path, "**")]
    end
    
    def clear_config
      @config = {}
    end

    def to_str
       @config
    end
        
    def read
      clear_config
      read_config_from_files(ConfigReader.config_files)
      plugin_config = PluginManager.config_files
      read_config_from_files(plugin_config)
    end    
    
    private 
    def read_config_from_files(files)
      files.each do |f|
        @config = @config.merge_yaml(f)
      end
    end
  end
end