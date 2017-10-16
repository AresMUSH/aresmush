module AresMUSH
  module Maps
    
   
    def self.available_maps
      GameMap.all.map { |m| m.name }
    end
    
    def self.get_map(name)
      GameMap.find_one_by_name(name)
    end
    
    def self.get_map_for_area(area)
      GameMap.all.select { |m| m.areas.include?(area) }.first
    end
  end
end