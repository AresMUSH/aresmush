require 'yaml'

module AresMUSH
  class ConfigReader    
    def initialize(game_dir)
      @config_path = File.join(game_dir, "config") 
      @txt_path = File.join(game_dir, "txt")
      clear_config
    end

    attr_accessor :txt, :config

    def clear_config
      @config = {}
      @txt = {}
    end
    
    def read
      clear_config
      @config = YamlExtensions.one_yaml_to_rule_them_all("#{@config_path}") 

      Dir.foreach("#{@txt_path}") do |f| 
        file_path = File.join(@txt_path, f)
        next if (File.directory?(file_path))
        file_txt = File.read( file_path ) 
        @txt[File.basename(f, ".*")] = file_txt
      end      
    end
  end
end