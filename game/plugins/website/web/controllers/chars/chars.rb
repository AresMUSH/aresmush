module AresMUSH
  class WebApp
    
    helpers do
      def display_damage_severity(severity)
        format_output_for_html FS3Combat.display_severity(severity)
      end
      
      def char_scenes_by_type(char, type)
        char.scenes_starring.select { |s| s.scene_type == type}
      end
      
      def can_manage_char?(char)
        @user && (@user == char || @user.is_admin?)
      end
      
      def profile_image_url(char)
        !char.profile_image.blank? ? "/files/#{char.profile_image}" : char.icon
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
        
        # Also support name lookup
        @char = Character.find_one_by_name(id)
        
        if (!@char)
          flash[:error] = "Character not found."
          redirect '/chars'
        end
      end
      
      erb :"chars/char"
    end
  end
end
