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
    
    def self.help
      HelpReader.help
    end
    
    mattr_accessor :config_reader, :client_monitor, :plugin_manager, :dispatcher, :locale, :help_reader
  end
end