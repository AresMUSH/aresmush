require 'yaml'

module AresMUSH
  class ConfigReader    
    def initialize(game_dir)
      @config_path = File.join(game_dir, "config") 
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
      read_config_files
    end
    
    private
    def read_config_files
      @config = YamlExtensions.one_yaml_to_rule_them_all("#{@config_path}") 
    end
  end
end