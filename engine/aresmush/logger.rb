module AresMUSH
  # @engineinternal true
  class AresLogger
    
    attr_accessor :logger
    
    def start
      create_log_dir(File.join(AresMUSH.game_path, "logs"))
      config = Global.read_config("logger")
      configurator = Log4r::YamlConfigurator
      configurator.decode_yaml config
      @logger = Log4r::Logger['ares']
    end
    
    def create_log_dir(dirname)
      unless File.directory?(dirname)
        FileUtils.mkdir_p(dirname)
      end
    end
  end
end
