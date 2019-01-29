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
          
          if (c.is_playerbit?)
            add_alt(players, c.name, c)
          end
            
          player_tag = Profile.get_player_tag(c)
          next if !player_tag
          
          add_alt(players, player_tag.titleize, c)
        end
        
        players.sort.map { |name, alts| { name: name, alts: alts }}
      end
      
      def add_alt(players, player_name, alt)
        if (players.has_key?(player_name))
          players[player_name] << alt_char_data(alt)
        else
          players[player_name] = [ alt_char_data(alt) ]
        end
      end
      
      def alt_char_data(char)
        {name: char.name, icon: Website.icon_for_char(char) }
      end
    end
  end
end