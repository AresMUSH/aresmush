module AresMUSH
  class Container
    def initialize(config_reader, client_monitor, plugin_manager, dispatcher, locale)
      @config_reader = config_reader
      @client_monitor = client_monitor
      @plugin_manager = plugin_manager
      @dispatcher = dispatcher
      @locale = locale
    end
      
    attr_accessor :config_reader, :client_monitor, :plugin_manager, :dispatcher, :locale
  end
end