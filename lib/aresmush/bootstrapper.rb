module AresMUSH

  class Bootstrapper 

    attr_reader :command_line
    
    def initialize
      config_reader = ConfigReader.new(Dir.pwd + "/game")
      config_reader.read
      port = config_reader.config['server']['port']

      client_monitor = ClientMonitor.new(config_reader)
      
      locale = Locale.new(config_reader, Dir.pwd + "/locales")
      
      server = Server.new(config_reader, client_monitor)
      @command_line = AresMUSH::CommandLine.new(server)
      locale.setup
      
      system_manager = SystemManager.new(config_reader, client_monitor)
      system_manager.load_all
    end   
    
  end

end