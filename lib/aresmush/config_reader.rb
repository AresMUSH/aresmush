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

    def to_str
       @config
    end
    
    def read
      clear_config
      read_config_files
      read_text_files
    end
    
    private
    def read_config_files
      @config = YamlExtensions.one_yaml_to_rule_them_all("#{@config_path}") 
    end

    def read_text_files
      Dir.foreach("#{@txt_path}") do |f| 
        file_path = File.join(@txt_path, f)
        next if (File.directory?(file_path))
        file_txt = File.read( file_path ) 
        @txt[File.basename(f, ".*")] = file_txt
      end
    end
  end
end