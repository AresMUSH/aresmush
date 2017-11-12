$:.unshift File.dirname(__FILE__)



module AresMUSH
  module Website
        
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      {}
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.config_files
      [ "config_website.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml"]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)       
      case cmd.root      
      when "website"
        return WebsiteCmd
      end
      
      nil
    end

    def self.get_event_handler(event_name) 
      case event_name
        when "WebCmdEvent"
          return WebCmdEventHandler
        when "ConfigUpdatedEvent", "GameStartedEvent"
          return WebConfigUpdatedEventHandler
      end
      
      nil
    end
  end
end
