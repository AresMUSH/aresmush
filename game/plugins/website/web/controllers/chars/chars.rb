module AresMUSH
  class WebApp
    
    helpers do
      def display_damage_severity(severity)
        format_output_for_html FS3Combat.display_severity(severity)
      end
      
    end
    get '/chars' do
      @npcs = Character.all.select { |c| c.is_npc? && !c.idled_out?}.group_by { |c| c.group("Faction") || "" }
      @factions = Chargen.approved_chars.group_by { |c| c.group("Faction") || "" }
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
