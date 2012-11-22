require 'yaml'

module AresMUSH
  class ConfigReader    
    def initialize
      clear_config
    end

    attr_accessor :config

    def self.config_path
      File.join(AresMUSH.game_path, "config") 
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
    
    # Shortcut method since it's used all over creation
    def line      
      "%x#{line_color}#{@config['theme']['line']}%xn"
    end

    # Randomly rotates between line colors in a list, based on the seconds value of the current time.
    def line_color
      colors = @config['theme']['line_colors']
      return "n" if colors.nil? || colors.empty?
      bracket_width = 60 / colors.count
      index = Time.now.sec / bracket_width
      colors[index]
    end
    
    private 
    def read_config_from_files(files)
      files.each do |f|
        @config = @config.merge_yaml(f)
      end
    end
  end
end