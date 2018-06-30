module AresMUSH
  module Maps
    def self.get_map_for_area(area_name)
      return nil if !area_name
      
      area = Area.find_one_by_name(area_name)
      return area.map if area.map
      
      GameMap.find_one_by_name(area_name)
    end
  end
end