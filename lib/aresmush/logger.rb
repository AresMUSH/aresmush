module AresMUSH
  class AresLogger
    def initialize(config_reader)
      @config_reader = config_reader
    end
    
    def start
      config = @config_reader.config['logger']
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
