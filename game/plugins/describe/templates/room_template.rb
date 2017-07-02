module AresMUSH
  module Describe
    # Template for a room.
    class RoomTemplate < ErbTemplateRenderer
             
      attr_accessor :room
                     
      def initialize(room, enactor)
        @room = room
        @enactor = enactor
        super File.dirname(__FILE__) + "/room.erb"        
      end
      
      def is_foyer
        @room.is_foyer?
      end
      
      # List of all exits in the room.
      def exits
        if (@room.is_foyer?)
          non_foyer_exits
        else
          @room.exits.sort_by(:name, :order => "ALPHA")
        end
      end
      
      # List of online characters, sorted by name.      
      def online_chars
        @room.characters.select { |c| c.is_online? }.sort_by { |c| c.name }
      end
      
      # Available detail views.
      def details
        @room.details.empty? ? nil : @room.details.sort_by(:name, :order => "ALPHA")
        .map { |d| d.name }.join(", ")
      end
      
      def logging_enabled
        @room.logging_enabled?
      end
      
      # Short IC date/time string
      def ic_time
        ICTime::Api.ic_datestr ICTime::Api.ictime
      end
      
      def area
        @room.area
      end
      
      # Room grid coordinates, e.g. (1,2)
      def grid
        "(#{@room.grid_x},#{@room.grid_y})"
      end
      
      def weather
         w = Weather::Api.weather_for_area(@room.area)
         w ? "#{w}%R" : nil
      end
      
      def ooc_time
        OOCTime::Api.local_short_timestr(@enactor, Time.now)
      end
      
      def foyer_exits
        @room.exits.select { |e| e.name.is_integer? }.sort_by { |e| e.name }
      end
      
      def non_foyer_exits
        @room.exits.select { |e| !e.name.is_integer? }.sort_by { |e| e.name }
      end
      
     
      def foyer_status(e, i)
        chars = e.dest.characters
        if (!e.lock_keys.empty?)
          status = t('describe.foyer_room_locked')
        elsif (chars.count == 0)
          status = t('describe.foyer_room_free')
        elsif (chars.select { |c| c.client }.count > 0 )
          status = t('describe.foyer_room_in_use')
        else
          status = t('describe.foyer_room_occupied')
        end
        linebreak = i % 2 == 0 ? "%R          " : ""
        room_name = "#{e.dest.name} (#{status})"
        "#{linebreak}%xh[#{e.name}]%xn #{left(room_name,29)}"
      end
      
      def char_shortdesc(char)
        char.shortdesc ? " - #{char.shortdesc.description}" : ""
      end
      
      # Shows the AFK message, if the player has set one, or the automatic AFK warning,
      # if the character has been idle for a really long time.
      def char_afk(char)
        if (char.is_afk?)
          msg = "%xy%xh<#{t('describe.afk')}>%xn"
          afk_message = char.afk_display
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
        locked =  e.allow_passage?(@enactor) ? "" : "%xr*#{t('describe.locked')}*%xn "
        name = e.dest ? e.dest.name : t('describe.nowhere')
        "#{locked}#{name}"
      end
      
      def exit_linebreak(i)
        i % 2 == 0 ? "%r" : ""
      end
    end
  end
end