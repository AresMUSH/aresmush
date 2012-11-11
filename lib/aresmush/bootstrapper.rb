module AresMUSH

  class Bootstrapper 

    attr_reader :command_line
    
    def initialize
      game_dir = File.join(Dir.pwd, "game")
      config_reader = ConfigReader.new(game_dir)
      ares_logger = AresLogger.new(config_reader)
      locale = Locale.new(config_reader, File.join(Dir.pwd, "locales"))
      addon_factory = AddonFactory.new
      addon_manager = AddonManager.new(addon_factory, game_dir)
      dispatcher = Dispatcher.new(addon_manager)
      client_monitor = ClientMonitor.new(config_reader, dispatcher)
      server = Server.new(config_reader, client_monitor)
      db = Database.new(config_reader)
      
      # Now that everything's created, give the factory a container of the main addon 
      # objects so that it can pass those along to the individual addons
      addon_factory.container = Container.new(config_reader, client_monitor, addon_manager, dispatcher)

      # Configure a trap for exiting.
      at_exit do
        if ($!.kind_of?(SystemExit))
          logger.info "Normal shutdown."
        elsif ($!.nil?)
          logger.info "Shutting down."
        else
          logger.fatal "Abnormal shutdown.  \nLast exception: (#{$!.inspect})\nBacktrace: \n#{$!.backtrace[1,10]}"
        end
      end
            
      # Order here is important!
      config_reader.read
      ares_logger.start
      db.connect
      locale.setup
      addon_manager.load_all
      
      logger.debug config_reader.config

      @command_line = AresMUSH::CommandLine.new(server)
      
    end   
    
    
    
  end

end