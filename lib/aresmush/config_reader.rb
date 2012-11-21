require 'yaml'

module AresMUSH
  class ConfigReader    
    def initialize
      @config_path = File.join(AresMUSH.game_dir, "config") 
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
  end
end