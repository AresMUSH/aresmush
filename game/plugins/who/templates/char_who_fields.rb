module AresMUSH
  module Who
    # Fields used in the who/where templates that relate to displaying
    # a particular character's info
    module WhoCharacterFields
      def char_name(char)
        left(char.name, 22)
      end

      def char_position(char)
        left(Groups::Api.group(char, "Position"), 19)
      end

      def char_handle(char)
        left(char.handle, 19)
      end
    
      def char_status(char)
        status = Status::Api.status(char)
        left("#{Status::Api.status_color(status)}#{status}%xn", 6)
      end
   
      def char_faction(char)
        left(Groups::Api.group(char, "Faction"), 15)
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