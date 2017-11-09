$:.unshift File.dirname(__FILE__)

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
    
    def self.get_cmd_handler(client, cmd, enactor)
       case cmd.root
       when "map"
         case cmd.switch
         when "create"
           return MapCreateCmd
         when "delete"
           return MapDeleteCmd
         when "area"
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
