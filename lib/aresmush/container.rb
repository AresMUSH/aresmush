module AresMUSH
  class Container
    def config_reader
      Global.config_reader
    end
    
    def client_monitor
      Global.client_monitor
    end
    
    def plugin_manager
      Global.plugin_manager
    end
    
    def dispatcher
      Global.dispatcher
    end
    
    def locale
      Global.locale
    end
  end
end

    