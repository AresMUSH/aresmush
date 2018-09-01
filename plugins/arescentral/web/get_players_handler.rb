module AresMUSH
  module AresCentral
    class GetPlayersRequestHandler
      def handle(request)
        players = {}
        
        Handle.all.each do |h|
          players[h.name] = AresCentral.alts_of(h).map { |a| alt_char_data(a) }
        end
        
        Character.all.each do |c|
          next if c.handle
          player_tag = c.profile_tags.select { |t| t.start_with?("player") }.first
          next if !player_tag

          player_tag = player_tag.after(":").titleize
          if (players.has_key?(player_tag))
            players[player_tag] << alt_char_data(c)
          else
            players[player_tag] = [ alt_char_data(c) ]
          end
        end
        
        players.sort.map { |name, alts| { name: name, alts: alts }}
      end
      
      def alt_char_data(char)
         {name: char.name, icon: Website.icon_for_char(char) }
      end
    end
  end
end


