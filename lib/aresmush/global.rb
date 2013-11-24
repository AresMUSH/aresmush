module AresMUSH
  
  module Global
    def self.db
      Database.db
    end
    
    def self.logger
      AresLogger.logger
    end
    
    def self.config_reader
      @@config_reader
    end
    
    def self.config_reader=(config_reader)
      @@config_reader = config_reader
    end
    
    def self.client_monitor
      @@client_monitor
    end
    
    def self.client_monitor=(client_monitor)
      @@client_monitor = client_monitor
    end
    
    def self.plugin_manager
      @@plugin_manager
    end
    
    def self.plugin_manager=(plugin_manager)
      @@plugin_manager = plugin_manager
    end
    
    def self.dispatcher
      @@dispatcher
    end
    
    def self.dispatcher=(dispatcher)
      @@dispatcher = dispatcher
    end
    
    def self.locale
      @@locale
    end
    
    def self.locale=(locale)
      @@locale = locale
    end
  end
end