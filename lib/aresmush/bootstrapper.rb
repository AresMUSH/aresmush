module AresMUSH

  class Bootstrapper 

    attr_reader :command_line
    
    def initialize
      game_dir = File.join(Dir.pwd, "game")
      config_reader = ConfigReader.new(game_dir)
      logger = AresLogger.new(config_reader)
      locale = Locale.new(config_reader, File.join(Dir.pwd, "locales"))
      system_factory = SystemFactory.new
      system_manager = SystemManager.new(system_factory, game_dir)
      dispatcher = Dispatcher.new(system_manager)
      client_monitor = ClientMonitor.new(config_reader, dispatcher)
      server = Server.new(config_reader, client_monitor)

      # Now that everything's created, give the factory a container of the main system 
      # objects so that it can pass those along to the individual systems
      system_factory.container = Container.new(config_reader, client_monitor, system_manager, dispatcher)

      # Make sure logger is first!!
      config_reader.read
      logger.start
      locale.setup
      system_manager.load_all

      @command_line = AresMUSH::CommandLine.new(server)
      
    end   
    
  end

end