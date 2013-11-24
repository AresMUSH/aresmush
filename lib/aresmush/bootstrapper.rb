module AresMUSH  
  
  class Bootstrapper 

    attr_reader :command_line
    
    def initialize
      config_reader = ConfigReader.new
      ares_logger = AresLogger.new
      locale = Locale.new
      client_factory = ClientFactory.new
      plugin_factory = PluginFactory.new
      plugin_manager = PluginManager.new(plugin_factory)
      dispatcher = Dispatcher.new(plugin_manager)
      client_monitor = ClientMonitor.new(dispatcher, client_factory)
      server = Server.new(client_monitor)
      db = Database.new
            
      # Now that everything's created, give the factory a container of the main plugin 
      # objects so that it can pass those along to the individual plugins
      container = Container.new(config_reader, client_monitor, plugin_manager, dispatcher, locale)
      plugin_factory.container = container
      
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
    
      Global.logger.debug config_reader.config

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