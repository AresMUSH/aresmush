module AresMUSH  
  class Bootstrapper 

    attr_reader :command_line
    
    def initialize
      config_reader = ConfigReader.new
      ares_logger = AresLogger.new
      locale = Locale.new
      plugin_factory = PluginFactory.new
      plugin_manager = PluginManager.new(plugin_factory)
      dispatcher = Dispatcher.new
      client_factory = ClientFactory.new
      client_monitor = ClientMonitor.new(client_factory)
      server = Server.new
      db = Database.new
            
      # Set up global access to the system objects - primarily so that the plugins can 
      # tell them to do things.
      Global.config_reader = config_reader
      Global.client_monitor = client_monitor
      Global.plugin_manager = plugin_manager
      Global.dispatcher = dispatcher
      Global.locale = locale
                  
      # Configure a trap for exiting.
      at_exit do
        handle_exit($!)
      end
      
      # Order here is important!
      config_reader.read
      ares_logger.start

      db.connect
      
      locale.setup
      plugin_manager.load_all
      
      api_router = ApiRouter.new(Game.master.api_game_id == ServerInfo.arescentral_game_id)
      Global.api_router = api_router
      api_router.find_handlers
    
      Global.logger.debug Global.config

      @command_line = AresMUSH::CommandLine.new(server)
    end
    
    def handle_exit(exception)
      if (exception.kind_of?(SystemExit))
        Global.logger.info "Normal shutdown."
      elsif (exception.nil?)
        Global.logger.info "Shutting down."
      else
        Global.logger.fatal "Abnormal shutdown.  \nLast exception: (#{exception.inspect})\nBacktrace: \n#{exception.backtrace[0,10]}"
      end
    end
    
  end

end