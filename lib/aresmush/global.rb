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
    
    mattr_accessor :config_reader, :plugin_manager, :locale, :help_reader, :database, :ares_logger, :notifier
  end
end