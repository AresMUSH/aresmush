require 'log4r'
require 'log4r/yamlconfigurator'
include Log4r

def logger
  logger = Log4r::Logger['ares']
  # For tests - use a dummy logger if one's not there already
  logger = Log4r::Logger.root if logger.nil?
  logger
end

module AresMUSH
  class AresLogger
    def initialize(config_reader)
      @config_reader = config_reader
    end
    
    def start
      config = @config_reader.config['log4r_config']
      configurator = Log4r::YamlConfigurator
      configurator.decode_yaml config
    end
  end
end