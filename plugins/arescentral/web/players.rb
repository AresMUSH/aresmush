module AresMUSH
  class WebApp
    get '/players/?' do
      @players = Handle.all.map { |h| [h.name, AresCentral.alts_of(h)]}.to_h
  
      Character.all.each do |c|
        next if c.handle
        player_tag = c.profile_tags.select { |t| t.start_with?("player") }.first
        next if !player_tag
    
        player_tag = player_tag.after(":").titleize
        if (@players.has_key?(player_tag))
          @players[player_tag] << c
        else
          @players[player_tag] = [ c ]
        end
      end
              
      erb :"players/players_index"
    end
    
    get '/player/:id/?' do |id|
      @char = Character.find_one_by_name(id)
              
      if (!@char)
        flash[:error] = "Character not found."
        redirect '/chars'
      end
      
      @page_title = "#{@char.name} - #{game_name}"      
      
      erb :"players/player"
    end
  end
end