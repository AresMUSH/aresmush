module AresMUSH
  
  class YamlFileParser
    
    def self.read(files, data)
      files.each do |f|
        Global.logger.debug "Reading data from #{f}"
        data = data.merge_yaml(f)
      end
      data
    end
    
  end
  
end