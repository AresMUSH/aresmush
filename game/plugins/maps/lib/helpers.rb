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
  end
end