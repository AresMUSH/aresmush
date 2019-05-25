module AresMUSH
  module Who
    class WhoRequestHandler
      def handle(request)
        who = {}
      
        Global.client_monitor.logged_in.each do |client, char|
          who[char.name] = build_who_data(char)
        end
      
        Global.client_monitor.web_clients.each do |client|
          char = Character[client.web_char_id]
          next if !char
          next if who.has_key?(char.name)
        
          who[char.name] = build_who_data(char)
        end
      
        {
          who_count: who.count,
          who: who.values.sort_by { |v| v[:name] }
        }
      end
    
      def build_who_data(char)
        {
          name: char.name,
          icon: Website.icon_for_char(char),
          status: Website.activity_status(char)
        }
      end
    end
  end
end


