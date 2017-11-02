$:.unshift File.dirname(__FILE__)

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
 
    def self.config_files
      [ "config_events.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "event"
        case cmd.switch
        when nil
          if (cmd.args)
            return EventDetailCmd
          else
            return EventsCmd
          end
        when "create"
          return EventCreateCmd
        when "edit"
          return EventEditCmd
        when "delete"
          return EventDeleteCmd
        when "update"
          return EventUpdateCmd
        end
      end
      
      nil
    end

    def self.get_event_handler(event_name) 
      case event_name
      when "CronEvent"
        return CronEventHandler
      end
      nil
    end
  end
end
