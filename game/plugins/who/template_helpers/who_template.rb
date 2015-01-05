module AresMUSH
  
  module Who
    # Who and where list template.
    class WhoTemplate
      include TemplateFormatters
    
      def initialize(chars)
        @chars = chars
      end
      
      # Total characers online.
      def online_total
        center(t('who.players_online', :count => @chars.count), 25)
      end
    
      # Total characters online and IC.
      def ic_total
        ic = @chars.select { |c| c.is_ic? }
        center(t('who.players_ic', :count => ic.count), 25)
      end
    
      # Max number of characters ever online
      def online_record
        center(t('who.online_record', :count => Game.online_record), 25)
      end
    
      # MUSH name
      def mush_name
        center(Global.config['server']['name'], 78)
      end
      
      # List of connected characters, sorted by room name then character name.
      # Usually you would use this in a list, like so:
      # Inside the loop, each char would be referenced as 'c'
      #    <% chars_by_room.each do |c| -%>
      #    <%= char_name(c) %> <%= char_faction(c) %>
      #    <% end %>
      def chars_by_room
        @chars.sort_by{ |c| [who_room_name(c), c.name] }
      end 
      
      # List of connected characters, sorted by handle name (if public) then character name.
      # Usually you would use this in a list, like so:
      # Inside the loop, each char would be referenced as 'c'
      #    <% chars_by_handle.each do |c| -%>
      #    <%= char_name(c) %> <%= char_faction(c) %>
      #    <% end %>
      def chars_by_handle
        @chars.sort_by{ |c| [c.public_handle? ? c.handle : "", c.name] }
      end
      
      # Character name.
      # Requires a character reference.  See 'characters' for details.
      def char_name(char)
        left(char.name, 22)
      end
    
      # Character position.
      # Requires a character reference.  See 'characters' for details.
      def char_position(char)
        left(char.groups["Position"], 19)
      end
    
      # Character's player handle, if they've made it public.
      # Requires a character reference.  See 'characters' for details.
      def char_handle(char)
        name = char.public_handle? ? char.handle : ""
        left(name, 19)
      end
        
      # Character status.
      # Requires a character reference.  See 'characters' for details.
      def char_status(char)
        left("#{Status.status_color(char.status)}#{char.status}%xn", 6)
      end
       
      # Character faction.
      # Requires a character reference.  See 'characters' for details.
      def char_faction(char)
        left(char.groups["Faction"], 15)
      end
    
      # How long a character's been idle, like 20m
      # Requires a character reference.  See 'characters' for details.
      def char_idle(char)
        left("#{TimeFormatter.format(char.client.idle_secs)}", 6)
      end   

      # How long a character's been connected, like 3h
      # Requires a character reference.  See 'characters' for details.
      def char_connected(char)
        left("#{TimeFormatter.format(char.client.connected_secs)}", 6)
      end   
    
      # Character room name.
      # Requires a character reference.  See 'characters' for details.
      def char_room(char)
        left(who_room_name(char), 35)
      end 
      
      # This is how the room name is displayed.  It is also used for
      # sorting purposes, so characters are sorted by area then individual rooms,
      # and unfindable characters are sorted together.
      def who_room_name(char)
        if (char.hidden)
          return t('who.hidden')
        end
      
        area = char.room.area.nil? ? "" : "#{char.room.area} - "
        "#{area}#{char.room.name}"
      end
    end  
  end
end