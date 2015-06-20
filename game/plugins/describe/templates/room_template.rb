module AresMUSH
  module Describe
    # Template for a room.
    class RoomTemplate
      include TemplateFormatters
                            
      def initialize(room, client)
        @room = room
        @client = client
      end
      
      def display
        text = header_display()
        text << "%r%l2%r"
        text << desc_display()
        text << "%r%l2%r"
        text << players_display()
        text << "%r%r"
        text << exits_display()
        text << "%r%l1"
        
        text
      end
      
      def header_display
        text = "%l1%r"
        text << "#{name} #{area}%r"
        text << "#{ooc_time} ~ #{ic_time}"
        
        text
      end
      
      def desc_display
        text = ""
        # Weather is disabled by default.  Uncomment this line to show it
        # in room descs.
        # text << "#{weather}"
        text << "#{description}"
        text << "#{details}"
        
        text
      end
      
      def players_display
        text = "%xg#{t('describe.players_title')}%xn"
        online_chars.each do |c|
          text << "%r%xh#{char_name(c)}%xn"
          text << " "
          text << char_shortdesc(c)
          text << " "
          text << char_afk(c)
        end
        
        text
      end
      
      def exits_display
        text = "%xg#{t('describe.exits_title')}%xn"
        exits.each_with_index do |e, i|
            
          # Linebreak every 2 exits.
          text << ((i % 2 == 0) ? "%r" : "")
          
          text << "%xh#{exit_name(e)}%xn"
          text << " "
          text << exit_destination(e)
        end
        
        if (exits.count == 0)
          text << "%r"
          text << t('desc.no_way_out')
        end
        
        if (@room.is_foyer)
          text << foyer()
        end

        text
      end
      
      # List of all exits in the room.
      def exits
        if (@room.is_foyer)
          non_foyer_exits
        else
          @room.exits.sort_by { |e| e.name }
        end
      end
      
      # List of online characters, sorted by name.      
      def online_chars
        @room.characters.select { |c| c.is_online? }.sort_by { |c| c.name }
      end
      
      def name
        left(@room.name, 40)
      end
      
      def description
        @room.description
      end
      
      # Available detail views.
      def details
        names = @room.details.keys
        return "" if names.empty?
        "%R%R%xh#{t('describe.details_available')}%xn #{names.sort.join(", ")}"
      end
      
      # Short IC date/time string
      def ic_time
        ICTime.ic_datestr ICTime.ictime
      end
      
      def area
        right(@room.area, 37)
      end
      
      # Room grid coordinates, e.g. (1,2)
      def grid
        "(#{@room.grid_x},#{@room.grid_y})"
      end
      
      def weather
         w = Weather.weather_for_area(@room.area)
         w ? "#{w}%R" : ""
      end
      
      def ooc_time
        OOCTime.local_long_timestr(@client, Time.now)
      end
      
      def foyer_exits
        @room.exits.select { |e| e.name.is_integer? }.sort_by { |e| e.name }
      end
      
      def non_foyer_exits
        @room.exits.select { |e| !e.name.is_integer? }.sort_by { |e| e.name }
      end
      
      # Special text displayed for the exits in a foyer.
      def foyer
        text = "%R%l2%R"
        text << center(t('describe.foyer_room_status'),78)
        foyer_exits.each_with_index do |e, i|
          if (!e.lock_keys.empty?)
            status = t('describe.foyer_room_locked')
          elsif (e.dest.characters.count == 0)
            status = t('describe.foyer_room_free')
          else
            status = t('describe.foyer_room_occupied')
          end
          text << "%r[space(10)]" if i % 2 == 0
          room_name = "#{e.dest.name} (#{status})"
          text << "%xh[#{e.name}]%xn #{left(room_name,29)}"
        end
        
        text
      end
      
      def char_name(char)
        char.name
      end

      def char_shortdesc(char)
        char.shortdesc ? " - #{char.shortdesc}" : ""
      end
      
      # Shows the AFK message, if the player has set one, or the automatic AFK warning,
      # if the character has been idle for a really long time.
      def char_afk(char)
        if (char.is_afk?)
          msg = "%xy%xh<#{t('describe.afk')}>%xn"
          if (char.afk_message)
            msg = "#{msg} %xy#{char.afk_message}%xn"
          end
        elsif (char.client && Status.is_idle?(char.client))
          "%xy%xh<#{t('describe.idle')}>%xn"
        else
          ""
        end
      end
      
      def exit_name(e)
        left("[#{e.name}]", 5)
      end
      
      def exit_destination(e)
        locked = e.allow_passage?(@client.char) ? "" : "%xr*#{t('describe.locked')}*%xn "
        name = e.dest ? e.dest.name : t('describe.nowhere')
        str = "#{locked}#{name}"
        left(str, 30)
      end
    end
  end
end