require 'yaml'

module AresMUSH
  class ConfigReader    
    def initialize(game_dir)
      @config_path = File.join(game_dir, "config") 
      @plugin_path = File.join(game_dir, "plugin") 
      clear_config
    end

    attr_accessor :config

    def clear_config
      @config = {}
    end

    def to_str
       @config
    end
    
    def read
      clear_config
      config_files = Dir.regular_files(@config_path)
      config_files.each do |f|
        @config = @config.merge_yaml(f)
      end
    end
    
    private
    def read_config_files
      
    end
  end
end