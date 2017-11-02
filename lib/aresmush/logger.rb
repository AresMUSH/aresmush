module AresMUSH
  class AresLogger
    
    attr_accessor :logger
    
    def start(logger_name)
      config = Global.read_config("logger")
      configurator = Log4r::YamlConfigurator
      configurator.decode_yaml config
      outputter = config['outputters'].select { |o| o['name'] == "#{logger_name}_file" }.first
      log_dir = outputter['filename'].gsub("log.txt", "")
      create_log_dir(log_dir)
      @logger = Log4r::Logger[logger_name]
    end
    
    def create_log_dir(dirname)
      unless File.directory?(dirname)
        FileUtils.mkdir_p(dirname)
      end
    end
  end
end
