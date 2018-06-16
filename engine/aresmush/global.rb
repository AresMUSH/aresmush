module AresMUSH
  
  module Global
    def self.logger
      ares_logger ? ares_logger.logger : Log4r::Logger.root
    end
    
    def self.read_config(section, key = nil, subkey = nil)
      config_reader.get_config(section, key, subkey)
    end
    
    def self.help
      help_reader.help
    end
    
    mattr_accessor :client_monitor, :config_reader, :dispatcher, :plugin_manager, :locale, :help_reader, :database, :ares_logger, :notifier, :use_api_proxy, :server_start
  end
end