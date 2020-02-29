module AresMUSH
  class ConfigReader
    
    attr_accessor :config, :text
    
    def initialize
      clear_config
    end

    def self.config_path
      File.join(AresMUSH.game_path, "config") 
    end

    def self.config_files
      Dir[File.join(ConfigReader.config_path, "**", "*.yml")]
    end

    def self.text_path
      File.join(AresMUSH.game_path, "text") 
    end

    def self.text_files
      Dir[File.join(ConfigReader.text_path, "**", "*.txt")]
    end

    def get_config(section_name, key = nil, subkey = nil)
      if (!key)
        return self.config[section_name]
      end
      
      section = self.config[section_name]
      return nil if !section
        
      subsection = section[key]
      
      if (!subkey)
        return subsection
      end
          
      return nil if !subsection
      return subsection[subkey]
    end

    def get_text(name)
      return self.text[name]
    end
    
    def clear_config
      self.config = {}
      self.text = {}
    end

    def validate_game_config
      tmp_config = {}
      
      # First check each file individually
      ConfigReader.config_files.each do |file|
        validate_config_file(file)
      end

      # Then try loading them all
      ConfigReader.config_files.each do |file|
        tmp_config = tmp_config.merge_yaml(file)
      end
    end
    
    def load_game_config
      clear_config
      ConfigReader.config_files.each do |file|
        self.load_config_file(file)
      end
      
      ConfigReader.text_files.each do |file|
        self.load_game_text_file(file)
      end
    end   
    
    # @engineinternal true
    def validate_config_file(file)
      begin
        AresMUSH::YamlExtensions.yaml_hash(file)
      rescue Exception => e
        raise "Error in config file: #{file}.  Error: #{e}"
      end
    end
    
    # @engineinternal true
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
    
    # @engineinternal true
    def load_game_text_file(file)
      Global.logger.debug "Loading text file #{file}."
      begin
        self.text[File.basename(file)] = File.read(file, :encoding => "UTF-8")
      rescue Exception => ex
        Global.logger.warn "Problem loading text file #{file}: #{ex}."
      end
    end
  end
end