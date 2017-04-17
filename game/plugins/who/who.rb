$:.unshift File.dirname(__FILE__)
load "lib/helpers.rb"
load "lib/hide_cmd.rb"
load "lib/where_cmd.rb"
load "lib/who_cmd.rb"
load "lib/who_events.rb"
load "lib/who_model.rb"
load "templates/char_who_fields.rb"
load "templates/common_who_fields.rb"
load "templates/where_template.rb"
load "templates/who_template.rb"

module AresMUSH
  module Who
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
      [  ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "hide", "unhide"
        return HideCmd
      when "where"
        return WhereCmd
      when "who"
        return WhoCmd        
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