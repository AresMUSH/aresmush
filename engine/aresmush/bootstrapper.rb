module AresMUSH  
  # @engineinternal true
  class Bootstrapper 
    
    attr_reader :server, :db, :ares_logger, :locale, :config_reader, :plugin_manager, :help_reader, :boot_options
    
    def initialize(boot_options = nil)

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
      @boot_options = boot_options || []
      
      # Set up global access to the system objects - primarily so that the plugins can 
      # tell them to do things.
      Global.config_reader = config_reader
      Global.plugin_manager = plugin_manager
      Global.locale = locale
      Global.help_reader = help_reader
      Global.database = @db
      Global.notifier = EngineNotifier.new      
      Global.client_monitor = client_monitor
      Global.dispatcher = dispatcher
    end
    
    def start
                        
      # Configure a trap for exiting.
      at_exit do
        handle_exit($!)
      end
      
      Global.server_start = Time.now
      
      # Order here is important!
      @config_reader.load_game_config      
      @ares_logger.start
      Global.ares_logger = @ares_logger

      Global.use_api_proxy = true
      @boot_options.each do |opt|
        if (opt == 'disableproxy')
          Global.use_api_proxy = false
        else
          Global.logger.error "Invalid boot option: #{opt}."
          raise "Invalid boot option."
        end
      end
      
      Global.logger.info "AresMUSH version #{AresMUSH.version}.  Boot Options: #{self.boot_options}.  API Proxy: #{Global.use_api_proxy}"

      @db.load_config
      @locale.setup
      @plugin_manager.load_all

      @help_reader.load_game_help
                
      begin
        game = Game.master
      rescue Exception => e
        Global.logger.fatal "Error connecting to database. Check your database configuration: #{e.inspect}"
        exit 1
      end
      
      @server.start
      
      sleep
    end
    
    def handle_exit(exception)
      if (exception.kind_of?(SystemExit))
        if (exception.status == 0)
          Global.logger.info "Normal shutdown."
        else
          Global.logger.warn "Abnormal shutdown.  See if there are any errors above."
        end
      elsif (!exception)
        Global.logger.info "Shutting down."
      else
        Global.logger.fatal "Game crash.  \nLast exception: (#{exception.inspect})\nBacktrace: \n#{exception.backtrace[0,10]}"
      end
    end
    
  end

end