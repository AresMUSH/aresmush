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
        left(@char.name, 20)
      end
    
      def position
        left(@char.position, 20)
      end
    
      def status
        left(@char.status, 6)
      end
    
      def faction
        left(@char.faction, 20)
      end
    
      def idle
        left("#{@client.idle_secs}m", 5)
      end   
    
      def room
        left(@char.who_room_name, 35)
      end 
    end
  end
end