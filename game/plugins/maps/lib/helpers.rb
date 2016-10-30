module AresMUSH
  module Maps
    
    def self.maps_dir
      File.join(File.dirname(__FILE__), "..", "maps")
    end
      
    def self.available_maps
      areas = Global.read_config("maps", "map_areas")
      maps = areas ? areas.keys : []
      
      overview = Global.read_config("maps", "master_map")
      if (overview)
        maps.concat overview.keys
      end
      maps
    end
    
    def self.get_map(name)
      map_file = Global.read_config("maps", "map_areas")[name]
      if (!map_file)
        master = Global.read_config("maps", "master_map")
        if (master)
          map_file = master.values.first
        end
      end
      map_file
    end
  end
end