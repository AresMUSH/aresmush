module AresMUSH
  class WebApp
    get '/chars' do
      @factions = Chargen.approved_chars.group_by { |c| c.group("Faction") }
      erb :"chars/index"
    end
    
    get '/char/:id' do |id|
      @char = Character[id]
      if (!@char)
        flash[:error] = "Character not found."
        redirect '/chars'
      end
      
      erb :"chars/char"
    end
  end
end
