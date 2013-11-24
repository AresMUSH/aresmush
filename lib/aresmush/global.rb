module AresMUSH
  
  module Global
    def self.db
      Database.db
    end
    
    def self.logger
      AresLogger.logger
    end
    
    def self.container
      @@container
    end
    
    def self.container=(container)
      @@container = container
    end
    
  end
end