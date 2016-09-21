$:.unshift File.dirname(__FILE__)
load "handles_api.rb"
load "lib/event_handlers.rb"
load "lib/handle_link_cmd.rb"
load "lib/handles_model.rb"

module AresMUSH
  module Handles
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
 
    def self.help_files
      [ "help/handles.md" ]
    end
 
    def self.config_files
      [  ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd)
      return nil if !cmd.root_is?("handle")
      
      case cmd.switch
      when "link"
        return HandleLinkCmd
      end
      
      nil
    end

    def self.get_event_handler(event_name) 
      case event_name
      when "CharConnectedEvent"
        return CharConnectedEventHandler
      end
      nil
    end
  end
end