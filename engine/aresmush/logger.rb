module AresMUSH
  # @engineinternal true
  class AresLogger
    
    attr_accessor :file_logger, :stdout_logger
    
    def initialize
      create_log_dir(self.logs_path)
      
      # Don't use config reader here because it hasn't been loaded yet.
      config = YAML::load( File.read( File.join( AresMUSH.game_path, "config", "logger.yml" )) )
      logger_config = config['logger'] || {}

      @file_logger = Logger.new('game/logs/log.txt', 
          logger_config['max_files'] || 10, 
          logger_config['max_size_bytes'] || 125000)
      @file_logger.formatter = proc { |severity, time, progname, msg| format_log_entry(severity, time, msg) }

      @stdout_logger = Logger.new($stdout)
      @stdout_logger.formatter = proc { |severity, time, progname, msg| format_log_entry(severity, time, msg) }
    end
    
    def logs_path
      File.join(AresMUSH.game_path, "logs")
    end
    
    def format_log_entry(severity, time, msg)
      
      # Could use msg.dump here to escape certain chars.
      "#{time} #{severity} - #{msg}\n"
    end
      
    def log_files
       Dir[File.join(self.logs_path, 'log.txt**')].sort
     end
     
     def latest_log_file
        self.log_files.first
      end
     
    def create_log_dir(dirname)
      unless File.directory?(dirname)
        FileUtils.mkdir_p(dirname)
      end
    end
    
    def fatal(msg)
      @file_logger.fatal msg
      @stdout_logger.fatal msg
    end
    
    def error(msg)
      @file_logger.error msg
      @stdout_logger.error msg
    end
    
    def warn(msg)
      @file_logger.warn msg
      @stdout_logger.warn msg
    end
        
    def info(msg)
      @file_logger.info msg
      @stdout_logger.info msg
    end
        
    def debug(msg)
      @file_logger.debug msg
      @stdout_logger.debug msg
    end
  end
end
