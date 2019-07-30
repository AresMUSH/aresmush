module AresMUSH
  module Places
    def self.place_title(place_name, same_place)
      color = Global.read_config("places", "same_place_color")
      prefix = Places.place_prefix(same_place)
      suffix = Places.place_suffix(same_place)
      default_format = "#{prefix} #{t('places.place_title', :place_name => place_name )} #{suffix} "
      same_place_format = "#{prefix}#{color} #{t('places.place_title', :place_name => place_name)} %xn#{suffix} "
      same_place ? same_place_format : default_format
    end

    def self.place_prefix(same_place)
      color = Global.read_config("places", "same_place_color")
      start_marker = Global.read_config("places", "start_marker") || '['
      same_place ? "#{color}#{start_marker}+%xn" : "%xh%xx#{start_marker}-%xn"
    end

    def self.place_suffix(same_place)
      color = Global.read_config("places", "same_place_color")
      end_marker = Global.read_config("places", "end_marker") || ']'
      same_place ? "#{color}+#{end_marker}%xn" : "%xh%xx-#{end_marker}%xn"
    end


    def self.clear_place(char, current_room)
      current_room.places.each do |p|
        p.characters.delete char
      end
    end

    def self.find_place(room, place_name)
      return nil if !place_name

      place = room.places.find(name_upcase: place_name.upcase).first
      return place if place

      room.places.select { |p| p.name_upcase.start_with?(place_name.upcase) }.first
    end
  end
end
