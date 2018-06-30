module AresMUSH
  module Maps
    
    def self.is_enabled?
      !Global.plugin_manager.is_disabled?("maps")
    end
   
    def self.available_maps
      GameMap.all.map { |m| m.name }
    end
    
    def self.get_map(name)
      GameMap.find_one_by_name(name)
    end
  end
end