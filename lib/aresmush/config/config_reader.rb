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
      Dir[File.join(ConfigReader.config_path, "**", "*.yml")]
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

    def validate_game_config
      ConfigReader.config_files.each do |file|
        validate_config_file(file)
      end
    end
    
    def load_game_config
      ConfigReader.config_files.each do |file|
        load_config_file(file)
      end
    end   
    
    def validate_config_file(file)
      begin
        AresMUSH::YamlExtensions.yaml_hash(file)
      rescue Exception => e
        raise "Error in config file: #{file}.  Error: #{e}"
      end
    end
    
    def load_config_file(file)
      Global.logger.debug "Loading config from #{file}."
      begin 
        validate_config_file(file)
        self.config = self.config.merge_yaml(file)
      rescue Exception => ex
        # Turn mysterious YAML errors into something a little more useful.
        Global.logger.error "Error reading YAML from #{file}.  See http://aresmush.com/tutorials for troubleshooting help: #{ex}"
      end
    end
    
  end
end