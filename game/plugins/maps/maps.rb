$:.unshift File.dirname(__FILE__)
load "lib/helpers.rb"
load "lib/map_cmd.rb"
load "lib/maps_cmd.rb"

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
      [ "help/map.md" ]
    end
 
    def self.config_files
      [ "config_maps.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
    end
 
    def self.get_cmd_handler(client, cmd)
       case cmd.root
       when "map"
         if (cmd.args)
           return MapCmd
         else
           return MapsCmd
         end
       end
       nil
    end

    def self.get_event_handler(event_name) 
    end
  end
end