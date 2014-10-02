module AresMUSH
  
  module Who
    class WhoTemplate
      include TemplateFormatters
    
      def initialize(clients)
        @clients = clients
      end
        
      def online_total
        center(t('who.players_online', :count => @clients.count), 25)
      end
    
      def ic_total
        ic = @clients.select { |c| c.char.is_ic? }
        center(t('who.players_ic', :count => ic.count), 25)
      end
    
      def online_record
        center(t('who.online_record', :count => Game.online_record), 25)
      end
    
      def mush_name
        center(Global.config['server']['name'], 78)
      end
      
      def clients
        @clients.sort_by{ |c| [c.char.who_room_name, c.char.name] }
      end 
    end  
  end
end