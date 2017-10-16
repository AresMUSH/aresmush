$:.unshift File.dirname(__FILE__)

load "models/wiki_page.rb"
load "models/wiki_page_version.rb"


load 'web_cmd_handler.rb'
load 'web_config_updated_handler.rb'
load 'website_cmd.rb'
load 'wiki_rebuild_cmd.rb'

module AresMUSH
  module Website
        
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      {}
    end
 
    def self.load_plugin
      FileUtils.touch(File.join(AresMUSH.root_path, "tmp", "restart.txt"))
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
      when "wiki"
        case cmd.switch
        when "rebuild"
          return WikiRebuildCmd
        end
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