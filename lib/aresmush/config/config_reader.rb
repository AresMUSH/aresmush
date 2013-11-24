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
      plugin_config = PluginManager.config_files
      @config = ConfigFileParser.read(ConfigReader.config_files, {} )
      @config = ConfigFileParser.read(plugin_config, @config)
    end    

    # Shortcut method since it's used all over creation
    # TODO MOVE
    def line(id)    
      "#{@config['theme']["line" + id]}"
    end

  end
end