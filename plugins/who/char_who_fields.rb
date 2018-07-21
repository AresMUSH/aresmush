module AresMUSH
  module Who
    # Fields used in the who/where templates that relate to displaying
    # a particular character's info
    module WhoCharacterFields
     
      def demographic(char, value)
        char.demographic(value)
      end
    
      def status_color(char)
        Status.status_color(char.status)
      end
      
      def name(char)
        Demographics.name_and_nickname(char)
      end
      
      def rank(char)
        char.rank
      end
      
      def status(char)
        "#{status_color(char)}#{char.status}%xn"
      end
   
      def group(char, value)
        char.group(value)
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
