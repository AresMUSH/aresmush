module AresMUSH
  class Container
    def initialize(config_reader, client_monitor, system_manager, dispatcher)
      @config_reader = config_reader
      @client_monitor = client_monitor
      @system_manager = system_manager
      @dispatcher = dispatcher
    end
      
    attr_accessor :config_reader, :client_monitor, :system_manager, :dispatcher
  end
end

    