module AresMUSH
  module AresCentral
    class GetPlayersRequestHandler
      def handle(request)
        players = {}
        
        Handle.all.each do |h|
          players["@#{h.name}"] = {
            name: h.name,
            alts: AresCentral.alts_of(h).map { |a| alt_char_data(a) },
            is_handle: true
          } 
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
        
        players.sort_by { |key, data| data[:name] }.map { |key, data| data }
      end
      
      def add_alt(players, player_name, alt)
        if (players.has_key?(player_name))
          alts = players[player_name][:alts]
          alts << alt_char_data(alt)
          players[player_name][:alts] = alts
        else
          players[player_name] = { name: player_name, alts: [ alt_char_data(alt) ], is_handle: false }
        end
      end
      
      def alt_char_data(char)
        {name: char.name, icon: Website.icon_for_char(char), is_handle: !!char.handle }
      end
    end
  end
end