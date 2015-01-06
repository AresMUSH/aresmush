module AresMUSH
  module Maps
    
    def self.maps_dir
      File.join(File.dirname(__FILE__), "..", "maps")
    end
      
    def self.available_map_files
      Dir["#{Maps.maps_dir}/*.txt"]
    end
    
    def self.available_maps
      Maps.available_map_files.map { |m| File.basename(m, ".txt") }.sort
    end
    
    def self.map_for_area(area)
      return nil if area.nil?
      return nil if !Maps.available_maps.include?(area.downcase)
      File.read(File.join(Maps.maps_dir, "#{area.downcase}.txt"), :encoding => "UTF-8")
    end
  end
end