module AresMUSH
  class Character
    def place_title(viewer)
      return "" if !self.place
      Places::Api.place_title(self.place.name, viewer.place == self.place)
    end
  end
  
  module Places
    module Api
      def self.place_title(place_name, same_place)
        color = Global.read_config("places", "same_place_color")
        default_format = "%xh%xx[#{place_name}]%xn%R"
        same_place_format = "#{color}[#{place_name}]%xn%R"
        same_place ? same_place_format : default_format
      end
      
      def self.clear_place(char)
        char.place.delete if char.place
      end
    end
  end
end