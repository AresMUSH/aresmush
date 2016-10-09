module AresMUSH
  module Who
    # Fields used in the who/where templates that relate to displaying
    # a particular character's info
    module WhoCharacterFields
     
      def position(char)
        char.group_value("Position")
      end
    
      def status_color(char)
        Status::Api.status_color(status(char))
      end
      
      def status(char)
        char.status
      end
   
      def faction(char)
        char.group_value("Faction")
      end

      # How long a character's been idle, like 20m
      def idle(char)
        TimeFormatter.format(char.client.idle_secs)
      end   

      # How long a character's been connected, like 3h
      def connected(char)
        TimeFormatter.format(char.client.connected_secs)
      end   

      # Name of the room the character is in.
      def room(char)
        Who.who_room_name(char)
      end 
    end
  end
end