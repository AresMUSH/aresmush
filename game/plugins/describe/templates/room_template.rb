module AresMUSH
  module Describe
    # Template for a room.
    class RoomTemplate < ErbTemplateRenderer
      include TemplateFormatters
             
      attr_accessor :client, :room
                     
      def initialize(room, client)
        @room = room
        @client = client
        super File.dirname(__FILE__) + "/room.erb"        
      end
      
      def is_foyer
        Rooms::Api.is_foyer?(@room)
      end
      
      # List of all exits in the room.
      def exits
        if (Rooms::Api.is_foyer?(@room))
          non_foyer_exits
        else
          @room.exits.sort_by { |e| e.name }
        end
      end
      
      # List of online characters, sorted by name.      
      def online_chars
        @room.characters.select { |c| c.is_online? }.sort_by { |c| c.name }
      end
      
      # Available detail views.
      def details
        names = @room.details.keys
        names.empty? ? nil : names.sort.join(", ")
      end
      
      # Short IC date/time string
      def ic_time
        ICTime::Api.ic_datestr ICTime::Api.ictime
      end
      
      def area
        Rooms::Api.area(@room)
      end
      
      # Room grid coordinates, e.g. (1,2)
      def grid
        "(#{Rooms::Api.grid_x(@room)},#{Rooms::Api.grid_y(@room)})"
      end
      
      def weather
         w = Weather::Api.weather_for_area(Rooms::Api.area(@room))
         w ? "#{w}%R" : nil
      end
      
      def ooc_time
        OOCTime::Api.local_long_timestr(@client, Time.now)
      end
      
      def foyer_exits
        @room.exits.select { |e| e.name.is_integer? }.sort_by { |e| e.name }
      end
      
      def non_foyer_exits
        @room.exits.select { |e| !e.name.is_integer? }.sort_by { |e| e.name }
      end
      
     
      def foyer_status(e, i)
        if (!e.lock_keys.empty?)
          status = t('describe.foyer_room_locked')
        elsif (e.dest.characters.count == 0)
          status = t('describe.foyer_room_free')
        else
          status = t('describe.foyer_room_occupied')
        end
        linebreak = i % 2 == 0 ? "%R          " : ""
        room_name = "#{e.dest.name} (#{status})"
        "#{linebreak}%xh[#{e.name}]%xn #{left(room_name,29)}"
      end
      
      def char_shortdesc(char)
        char.shortdesc ? " - #{char.shortdesc}" : ""
      end
      
      # Shows the AFK message, if the player has set one, or the automatic AFK warning,
      # if the character has been idle for a really long time.
      def char_afk(char)
        if (Status::Api.is_afk?(char))
          msg = "%xy%xh<#{t('describe.afk')}>%xn"
          afk_message = Status::Api.afk_message(char)
          if (afk_message)
            msg = "#{msg} %xy#{afk_message}%xn"
          end
          msg
        elsif (char.client && Status::Api.is_idle?(char.client))
          "%xy%xh<#{t('describe.idle')}>%xn"
        else
          ""
        end
      end
      
      def exit_name(e)
        "[#{e.name}]"
      end
      
      def exit_destination(e)
        locked = Rooms::Api.can_use_exit?(e, self.client.char) ? "" : "%xr*#{t('describe.locked')}*%xn "
        name = e.dest ? e.dest.name : t('describe.nowhere')
        "#{locked}#{name}"
      end
      
      def exit_linebreak(i)
        i % 2 == 0 ? "%r" : ""
      end
    end
  end
end