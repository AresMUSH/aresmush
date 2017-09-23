$:.unshift File.dirname(__FILE__)
load "lib/cron_event_handler.rb"
load "lib/place_create_cmd.rb"
load "lib/place_emit_cmd.rb"
load "lib/place_delete_cmd.rb"
load "lib/place_join_cmd.rb"
load "lib/place_leave_cmd.rb"
load "lib/place_rename_cmd.rb"
load "lib/places_cmd.rb"
load "public/places_api.rb"
load "public/places_model.rb"
load "templates/places_template.rb"

module AresMUSH
  module Places
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("places", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
    
    def self.config_files
      [ "config_places.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
       case cmd.root
       when "place"
         case cmd.switch
         when nil
           return PlacesCmd
         when "create"
           return PlaceCreateCmd
         when "emit"
           return PlaceEmitCmd
         when "delete"
           return PlaceDeleteCmd
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