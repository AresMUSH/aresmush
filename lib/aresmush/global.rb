module AresMUSH
  
  module Global
    def self.db
      Database.db
    end
    
    def self.logger
      AresLogger.logger
    end
    
    def self.config
      ConfigReader.config
    end
  end
end