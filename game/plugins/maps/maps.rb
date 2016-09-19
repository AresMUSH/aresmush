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
 
    def self.handle_command(client, cmd)
       Global.dispatcher.temp_dispatch(client, cmd)
    end

    def self.handle_event(event)
    end
  end
end