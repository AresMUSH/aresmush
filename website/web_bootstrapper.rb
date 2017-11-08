module AresMUSH  
  class WebBootstrapper 
    
    attr_reader :db, :ares_logger, :locale, :config_reader, :plugin_manager, :help_reader, :notifier
    
    def initialize
      @config_reader = ConfigReader.new
      @ares_logger = AresLogger.new
      @locale = Locale.new
      @plugin_manager = PluginManager.new
      @help_reader = HelpReader.new
      @db = Database.new
      
      # Set up global access to the system objects - primarily so that the plugins can 
      # tell them to do things.
      Global.config_reader = config_reader
      Global.plugin_manager = plugin_manager
      Global.locale = locale
      Global.help_reader = help_reader
      Global.database = @db
      Global.notifier = WebNotifier.new
    end
    
    def start
      
      # Trim the size of the server log.
      webserver_log = File.join(AresMUSH.game_path, "logs", "webserver.log")
      if (File.size(webserver_log) > 100000)
        lines = File.readlines(webserver_log)
        File.open(webserver_log, "w+") { |f| f.write lines[lines.count / 2, -1]}
      end

      # Order here is important!
      @config_reader.load_game_config      
      @ares_logger.start("web")
      Global.ares_logger = @ares_logger

      @db.load_config
      @locale.setup
      @plugin_manager.load_all(:web)
    end
    
  end

end