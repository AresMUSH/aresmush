module AresMUSH  
  module Who
    class WhoClientTemplate
      include TemplateFormatters
      
      def initialize(client)
        @client = client
        @char = client.char
      end
    
      def char
        @char
      end
      
      def name
        left(@char.name, 22)
      end
    
      def position
        left(@char.position, 19)
      end
    
      def status
        left(@char.status, 6)
      end
    
      def faction
        left(@char.faction, 15)
      end
    
      def idle
        left("#{TimeFormatter.format(@client.idle_secs)}", 6)
      end   

      def connected
        left("#{TimeFormatter.format(@client.connected_secs)}", 6)
      end   
    
      def room
        left(@char.who_room_name, 35)
      end 
    end
  end
end