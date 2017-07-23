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
      
      def subgroup_chars(group_data)
        subgroup = Global.read_config("website", "character_gallery_subgroup") || "Position"
        group_data.group_by { |c| c.group(subgroup) || "" }.sort
      end
    end
    
    get '/chars' do
      @npcs = Character.all.select { |c| c.is_npc? && !c.idled_out?}.group_by { |c| c.group("Faction") || "" }
      group = Global.read_config("website", "character_gallery_group") || "Faction"
      @groups = Chargen.approved_chars.group_by { |c| c.group(group) || "" }.sort
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
    
    get '/char/:id/source' do |id|
      @char = Character[id]
      
      if (!@char)
        flash[:error] = "Character not found."
        redirect '/chars'
      end
      
      erb :"chars/source"
    end
  end
end
