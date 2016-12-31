$:.unshift File.dirname(__FILE__)
load "lib/helpers.rb"
load "lib/map_cmd.rb"
load "lib/maps_cmd.rb"
load "lib/maps_model.rb"
load "lib/map_create_cmd.rb"
load "lib/map_delete_cmd.rb"
load "lib/map_areas_cmd.rb"

module AresMUSH
  module Maps
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("maps", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.help_files
      [ "help/map.md", "help/admin_map.md" ]
    end
 
    def self.config_files
      [ "config_maps.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
       case cmd.root
       when "map"
         case cmd.switch
         when "create"
           return MapCreateCmd
         when "delete"
           return MapDeleteCmd
         when "areas"
           return MapAreasCmd
         when nil
           return MapCmd
         end
       when "maps"
         return MapsCmd
       end
       nil
    end

    def self.get_event_handler(event_name) 
      nil
    end
  end
end