module AresMUSH
  module Describe
    # Template for a room.
    class RoomTemplate
      include TemplateFormatters
                            
      def initialize(room, client)
        @room = room
        @client = client
      end
      
      # List of all exits in the room.
      # You would typically use this in a loop with a counter, such as in the example below.
      # Inside the loop, each exit would be referenced as 'e'
      #    <% exits.each_with_index do |e, i| -%>
      #    <%= exit_name(e) %> <%= exit_destination(e) %>
      #    <% end %>
      def exits
        @room.exits.sort_by { |e| e.name }
      end
      
      # List of online characters, sorted by name.      
      # You would typically use this in a loop, such as in the example below.
      # Inside the loop, each character would be referenced as 'c'
      #    <% online_chars.each do |c| -%>
      #    <%= char_name(c) %> <%= char_shortdesc(c) %>
      #    <% end %>
      def online_chars
        @room.characters.select { |c| c.is_online? }.sort_by { |c| c.name }
      end
      
      # Room name
      def name
        left(@room.name, 40)
      end
      
      # Room description
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
      
      # Room area
      def area
        right(@room.area, 37)
      end
      
      # Room grid coordinates, e.g. (1,2)
      def grid
        "(#{@room.grid_x},#{@room.grid_y})"
      end
      
      # OOC date/time string
      def ooc_time
        OOCTime.local_long_timestr(@client, Time.now)
      end
      
      # Character name.
      # Requires a character reference.  See 'online_chars' for more info.
      def char_name(char)
        char.name
      end

      # Short chracter description.
      # Requires a character reference.  See 'online_chars' for more info.
      def char_shortdesc(char)
        char.shortdesc ? " - #{char.shortdesc}" : ""
      end
      
      # Shows the AFK message, if the player has set one, or the automatic AFK warning,
      # if the character has been idle for a really long time.
      # Requires a character reference.  See 'online_chars' for more info.
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
      
      # This is a special function that will print a linebreak after every 2 exits, 
      # but not after the very first one.
      # Require an exit counter.  See 'exits' for more info.
      def linebreak_every_two_exits(i)
        (i != 0 && i % 2 == 0) ? "%r" : ""
      end
      
      # Exit name
      # Requires an exit reference.  See 'exits' for more info.
      def exit_name(e)
        left("[#{e.name}]", 5)
      end
      
      # Exit destination
      # Requires an exit reference.  See 'exits' for more info.
      def exit_destination(e)
        locked = e.allow_passage?(@client.char) ? "" : "%xr*#{t('describe.locked')}*%xn "
        str = "#{locked}#{e.dest.name}"
        left(str, 30)
      end
    end
  end
end