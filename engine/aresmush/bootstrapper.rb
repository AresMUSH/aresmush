module AresMUSH  
  class Bootstrapper 
    
    attr_reader :server, :db, :ares_logger, :locale, :config_reader, :plugin_manager, :help_reader
    
    def initialize
      @config_reader = ConfigReader.new
      @ares_logger = AresLogger.new
      @locale = Locale.new
      @plugin_manager = PluginManager.new
      @help_reader = HelpReader.new
      dispatcher = Dispatcher.new
      client_factory = ClientFactory.new
      client_monitor = ClientMonitor.new(client_factory)
      @server = Server.new
      @db = Database.new
      
      # Set up global access to the system objects - primarily so that the plugins can 
      # tell them to do things.
      Global.config_reader = config_reader
      Global.client_monitor = client_monitor
      Global.plugin_manager = plugin_manager
      Global.dispatcher = dispatcher
      Global.locale = locale
      Global.help_reader = help_reader
      Global.database = @db
    end
    
    def start
                        
      # Configure a trap for exiting.
      at_exit do
        handle_exit($!)
      end
      
      # Order here is important!
      @config_reader.load_game_config      
      @ares_logger.start

      @db.load_config
      @locale.setup
      @plugin_manager.load_all

      @help_reader.load_game_help
                
      begin
        game = Game.master
      rescue Exception => e
        raise "Error connecting to database. Check your database configuration."
      end
            
      Global.logger.debug Global.config_reader.config
      
      @server.start
      sleep
    end
    
    def handle_exit(exception)
      if (exception.kind_of?(SystemExit))
        Global.logger.info "Normal shutdown."
      elsif (!exception)
        Global.logger.info "Shutting down."
      else
        Global.logger.fatal "Abnormal shutdown.  \nLast exception: (#{exception.inspect})\nBacktrace: \n#{exception.backtrace[0,10]}"
      end
    end
    
  end

end