require 'log4r'
include Log4r

def logger
  logger = Log4r::Logger['ares']
  # For tests - use a dummy logger if one's not there already
  logger = Log4r::Logger.root if logger.nil?
  logger
end

module AresMUSH
  class AresLogger
    def initialize(game_dir)
      @log_dir = File.join(game_dir, "logs")
      @logger = Log4r::Logger.new('ares')
    end
    
    def start
      Dir.mkdir @log_dir if !Dir.exists?(@log_dir)

      formatter = Log4r::PatternFormatter.new(:pattern => "%d %l - %M")
      file_outputter = FileOutputter.new('fileOutputter', :filename => File.join(@log_dir, "log.txt"), :formatter => formatter)
      @logger.outputters << Log4r::StdoutOutputter.new('stdoutOutputter', :formatter => formatter)
      @logger.outputters << file_outputter      
    end
    
  end
end