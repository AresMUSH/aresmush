module AresMUSH
  module Who
    # Fields used in the who/where templates that relate to displaying
    # a particular character's info
    module WhoCharacterFields
      def char_name(char)
        left(char.name, 22)
      end

      def char_position(char)
        left(Groups::Interface.group(char, "Position"), 19)
      end

      # Character's player handle, if they've made it public.
      def char_handle(char)
        name = char.public_handle? ? char.handle : ""
        left(name, 19)
      end
    
      def char_status(char)
        status = Status::Interface.status(char)
        left("#{Status::Interface.status_color(status)}#{status}%xn", 6)
      end
   
      def char_faction(char)
        left(Groups::Interface.group(char, "Faction"), 15)
      end

      # How long a character's been idle, like 20m
      def char_idle(char)
        left("#{TimeFormatter.format(char.client.idle_secs)}", 4)
      end   

      # How long a character's been connected, like 3h
      def char_connected(char)
        left("#{TimeFormatter.format(char.client.connected_secs)}", 6)
      end   

      # Name of the room the character is in.
      def char_room(char)
        left(Who.who_room_name(char), 35)
      end 
    end
  end
end