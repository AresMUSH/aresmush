$:.unshift File.dirname(__FILE__)
load "places_api.rb"
load "lib/places_model.rb"
load "lib/places_events.rb"
load "lib/place_create_cmd.rb"
load "lib/place_join_cmd.rb"
load "lib/place_leave_cmd.rb"
load "lib/place_rename_cmd.rb"
load "lib/places_cmd.rb"
load "templates/places_template.rb"

module AresMUSH
  module Places
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
      [ "help/places.md" ]
    end
 
    def self.config_files
      [ "config_places.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
       case cmd.root
       when "places"
         return PlacesCmd
       when "place"
         case cmd.switch
         when "create"
           return PlaceCreateCmd
         when "join"
           return PlaceJoinCmd
         when "leave"
           return PlaceLeaveCmd
         when "rename"
           return PlaceRenameCmd
         end
       end
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