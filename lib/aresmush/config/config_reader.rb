module AresMUSH
  class ConfigReader
    
    attr_accessor :config
    
    def initialize
      clear_config
    end

    def self.config_path
      File.join(AresMUSH.game_path, "config") 
    end

    def self.config_files
      Dir[File.join(ConfigReader.config_path, "**")]
    end

    def get_config(section_name, key = nil, subkey = nil)
      if (!key)
        return self.config[section_name]
      end
      
      section = self.config[section_name]
      raise "Config section #{section_name} not found." if !section
        
      subsection = section[key]
      
      if (!subkey)
        return subsection
      end
          
      raise "Config section #{section_name}/#{key} not found." if !subsection
      return subsection[subkey]
    end
    
    def clear_config
      self.config = {}
    end

    def read
      plugin_config = PluginManager.config_files

      # Don't wipe out the existing config until we know the temp one has
      # loaded without raising an exception 
      temp_config = YamlFileParser.read(ConfigReader.config_files, {} )
      temp_config = YamlFileParser.read(plugin_config, temp_config)
      self.config = temp_config
      if (!Global.dispatcher.nil?)
        Global.dispatcher.queue_event ConfigUpdatedEvent.new
      end
    end    
  end
end