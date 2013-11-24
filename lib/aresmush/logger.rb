module AresMUSH
  class AresLogger
    def start
      config = Global.config['logger']
      configurator = Log4r::YamlConfigurator
      configurator.decode_yaml config
    end
    
    def self.logger
      logger = Log4r::Logger['ares']
      # For tests - use a dummy logger if one's not there already
      logger = Log4r::Logger.root if logger.nil?
      logger
    end
  end
end
