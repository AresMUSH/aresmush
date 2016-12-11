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
    
    def self.load_map(map_file)
      File.read(File.join(Maps.maps_dir, map_file), :encoding => "UTF-8")
    end
    
    def self.save_map(map_file, text)
      path = File.join(Maps.maps_dir, map_file)
      File.open(path, 'w', :encoding => "UTF-8") { |file| file.write(text) }
    end
    
    def self.get_map_file(name)
      areas = Global.read_config("maps", "map_areas")
      map_file = areas ? areas[name] : nil
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