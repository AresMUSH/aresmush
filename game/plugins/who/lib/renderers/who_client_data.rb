module AresMUSH  
  module Who
    class WhoClientData
      def initialize(client)
        @client = client
        @char = client.char
      end
    
      def char
        @char
      end
      
      def name
        @char.name
      end
    
      def position
        @char.position
      end
    
      def status
        @char.status
      end
    
      def faction
        @char.faction
      end
    
      def idle_time
        "#{@client.idle_secs}m"
      end   
    
      def room
        @char.who_location
      end 
    end
  end
end