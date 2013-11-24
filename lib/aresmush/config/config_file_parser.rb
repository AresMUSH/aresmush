module AresMUSH
  
  class ConfigFileParser
    
    def self.read(files, config)
      files.each do |f|
        Global.logger.debug "Reading config from #{f}"
        config = config.merge_yaml(f)
      end
      config
    end
    
  end
  
end