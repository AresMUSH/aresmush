module AresMUSH
  class AresLogger
    def start
      config = Global.read_config("logger")
      config['outputters'][1]['filename'] = File.join(AresMUSH.logs_path, "log.txt")
      configurator = Log4r::YamlConfigurator
      configurator.decode_yaml config
    end
    
    def self.logger
      create_log_dir
      logger = Log4r::Logger['ares']
      # For tests - use a dummy logger if one's not there already
      logger = Log4r::Logger.root if !logger
      logger
    end
    
    def self.create_log_dir
      dirname = AresMUSH.logs_path
      unless File.directory?(dirname)
        FileUtils.mkdir_p(dirname)
      end
    end
  end
end
