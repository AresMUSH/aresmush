module AresMUSH
  class Container
    def initialize(config_reader, client_monitor, plugin_manager, dispatcher)
      @config_reader = config_reader
      @client_monitor = client_monitor
      @plugin_manager = plugin_manager
      @dispatcher = dispatcher
    end
      
    attr_accessor :config_reader, :client_monitor, :plugin_manager, :dispatcher
  end
end

    