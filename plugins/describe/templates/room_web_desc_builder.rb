module AresMUSH
  module Describe
    class RoomWebDescBuilder
      def self.build(room)
        desc = "#{room.description}"

        time_of_day = ICTime.time_of_day(room.area_name).titleize
        if (room.vistas && room.vistas.has_key?(time_of_day))
          desc << " "
          desc << room.vistas[time_of_day]
        end

        season = ICTime.season(room.area_name).titleize
        if (room.vistas && room.vistas.has_key?(season))
          desc << " "
          desc << room.vistas[season]
        end

          desc
      end

    
    end
  end
end
