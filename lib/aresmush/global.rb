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
    
    mattr_accessor :config_reader, :client_monitor, :plugin_manager, :dispatcher, :locale
  end
end