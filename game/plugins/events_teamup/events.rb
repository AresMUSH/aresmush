$:.unshift File.dirname(__FILE__)
load "events_api.rb"
load "lib/events_cmd.rb"
load "lib/event_detail_cmd.rb"
load "lib/helpers.rb"
load "lib/teamup.rb"
load "templates/events_list_template.rb"
load "templates/event_detail_template.rb"

module AresMUSH
  module Events
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("events", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/events.md" ]
    end
 
    def self.config_files
      [ "config_events.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "event"
        if (cmd.args)
          return EventDetailCmd
        else
          return EventsCmd
        end
      end
      
      nil
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end