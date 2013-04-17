module AresMUSH
  
  class Bootstrapper 

    attr_reader :command_line
    
    def initialize
      config_reader = ConfigReader.new
      ares_logger = AresLogger.new(config_reader)
      locale = Locale.new(config_reader)
      client_factory = ClientFactory.new
      plugin_factory = PluginFactory.new
      plugin_manager = PluginManager.new(plugin_factory)
      dispatcher = Dispatcher.new(plugin_manager)
      client_monitor = ClientMonitor.new(config_reader, dispatcher, client_factory)
      server = Server.new(config_reader, client_monitor)
      db = Database.new(config_reader)
            
      # Now that everything's created, give the factory a container of the main plugin 
      # objects so that it can pass those along to the individual plugins
      container = Container.new(config_reader, client_monitor, plugin_manager, dispatcher, locale)
      plugin_factory.container = container
      client_factory.container = container

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
      
      logger.debug config_reader.config

      @command_line = AresMUSH::CommandLine.new(server)
    end
    
    def handle_exit(exception)
      if (exception.kind_of?(SystemExit))
        logger.info "Normal shutdown."
      elsif (exception.nil?)
        logger.info "Shutting down."
      else
        logger.fatal "Abnormal shutdown.  \nLast exception: (#{exception.inspect})\nBacktrace: \n#{exception.backtrace[0,10]}"
      end
    end
    
  end

end