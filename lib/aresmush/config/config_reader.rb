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

    def get_config(section, subsection=nil)
      if (subsection.nil?)
        return self.config[section]
      else
        section = self.config[section]
        return section.nil? ? nil : section[subsection]
      end
    end
    
    def clear_config
      self.config = {}
    end

    def read
      plugin_config = PluginManager.config_files
      self.config = YamlFileParser.read(ConfigReader.config_files, {} )
      self.config = YamlFileParser.read(plugin_config, self.config)
    end    
  end
end