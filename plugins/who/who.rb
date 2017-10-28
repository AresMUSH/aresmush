$:.unshift File.dirname(__FILE__)
load "engine/hide_cmd.rb"
load "engine/where_cmd.rb"
load "engine/who_cmd.rb"
load "engine/who_events.rb"
load "engine/whois_cmd.rb"
load "engine/templates/char_who_fields.rb"
load "engine/templates/common_who_fields.rb"
load "engine/templates/where_template.rb"
load "engine/templates/who_template.rb"
load "lib/who_model.rb"
load "lib/helpers.rb"
load "web/who.rb"

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
      when "whois"
        return WhoisCmd
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