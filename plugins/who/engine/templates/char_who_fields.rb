module AresMUSH
  module Who
    # Fields used in the who/where templates that relate to displaying
    # a particular character's info
    module WhoCharacterFields
     
      def position(char)
        char.group("Position")
      end
    
      def status_color(char)
        Status.status_color(status(char))
      end
      
      def status(char)
        char.status
      end
   
      def faction(char)
        char.group("Faction")
      end

      def position(char)
        char.group("Position")
      end

      def department(char)
        char.group("Department")
      end
      
      def idle(char)
        TimeFormatter.format(Login.find_client(char).idle_secs)
      end   

      def connected(char)
        TimeFormatter.format(Login.find_client(char).connected_secs)
      end   

      def room(char)
        Who.who_room_name(char)
      end 

      def handle(char)
        char.handle ? "@#{char.handle.name}" : ""
      end
    end
  end
end
