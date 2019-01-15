module AresMUSH
  module Places
    def self.place_title(place_name, same_place)
      color = Global.read_config("places", "same_place_color")
      default_format = "%xh%xx[#{place_name}]%xn%R"
      same_place_format = "#{color}[#{place_name}]%xn%R"
      same_place ? same_place_format : default_format
    end
      
    def self.clear_place(char)
      char.update(place: nil)
    end
    
    def self.reset_place_if_moved(char)
      if (char.place && char.place.room != char.room)
        char.upate(place: nil)
      end
    end
      
    def self.find_place(char, place_name)
      return nil if !place_name
      
      place = char.room.places.find(name_upcase: place_name.upcase).first
      return place if place
      
      char.room.places.select { |p| p.name_upcase.start_with?(place_name.upcase) }.first
    end
  end
end