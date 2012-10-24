module AresMUSH

  class Bootstrapper 

    attr_reader :command_line
    
    def initialize
      config_reader = ConfigReader.new(Dir.pwd + "/game")
      locale = Locale.new(config_reader, Dir.pwd + "/locales")
      system_factory = SystemFactory.new
      system_manager = SystemManager.new(system_factory)
      dispatcher = Dispatcher.new(system_manager)
      client_monitor = ClientMonitor.new(config_reader, dispatcher)
      server = Server.new(config_reader, client_monitor)

      system_factory.container = Container.new(config_reader, client_monitor, system_manager)

      config_reader.read
      locale.setup
      system_manager.load_all

      @command_line = AresMUSH::CommandLine.new(server)
      
    end   
    
  end

end