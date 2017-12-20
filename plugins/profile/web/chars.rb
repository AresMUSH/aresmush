module AresMUSH
  class WebApp
    
    helpers do
      
      def char_scenes_by_type(char, type)
        char.scenes_starring.select { |s| s.scene_type == type}
            .select { |s| s.shared }
            .sort_by { |s| s.icdate }
            .reverse
      end
      
      def can_manage_char?(char)
        return false if !@user
        return true if @user.is_admin?
        return true if @user == char
        
        return AresCentral.is_alt?(@user, char)
      end
      
      def profile_image_url(char)
        !char.profile_image.blank? ? "/files/#{char.profile_image}" : "/theme_images/noicon.png"
      end
      
      def subgroup_chars(group_data)
        subgroup = Global.read_config("website", "character_gallery_subgroup") || "Position"
        group_data.group_by { |c| c.group(subgroup) || "" }.sort
      end
    end
    
    get '/chars/?' do
      group = Global.read_config("website", "character_gallery_group") || "Faction"
      @npcs = Character.all.select { |c| c.is_npc? && !c.idled_out?}.group_by { |c| c.group(group) || "" }
      @groups = Chargen.approved_chars.group_by { |c| c.group(group) || "" }.sort
      @page_title = "Characters - #{game_name}"
      
      erb :"chars/chars_index"
    end
    
    get %r{/char\:([\w]+)/?} do |id|
      redirect "/char/#{id}"
    end
    
    get '/char/:id/?' do |id|
      @char = Character.find_one_by_name(id)
              
      if (!@char)
        flash[:error] = "Character not found."
        redirect '/chars'
      end
      
      if (@char.is_admin? || @char.is_playerbit?)
        redirect "/player/#{@char.name}"
      end
      
      @page_title = "#{@char.name} - #{game_name}"
          
      case @char.idle_state
      when "Roster"
        @idle_message = "This character is on the roster.<br/>#{@char.roster_notes}"
      when "Gone"
        @idle_message = "This character is retired."
      when "Dead"
        @idle_message = "This character is deceased."
      else
        if (@char.is_npc?)
          @idle_message = "This character is a NPC."
        elsif (@char.is_admin?)
          @idle_message = "This character is a game administrator."
        elsif (@char.is_playerbit?)
          @idle_message = "This character is a player bit."
        elsif (!@char.is_approved?)
          @idle_message = "This character is not yet approved."
        else
          @idle_message = nil
        end
      end
      
      erb :"chars/char"
    end
    
    get '/char/:id/source/?' do |id|
      @char = Character.find_one_by_name(id)
      
      if (!@char)
        flash[:error] = "Character not found."
        redirect '/chars'
      end

      @version = @char.last_profile_version

      if (!@version)
        flash[:error] = "Version not found."
        redirect '/chars'
      end
      
      redirect "/char/#{id}/source/#{@version.id}"
    end
    
    get '/char/:id/source/:version/?' do |id, versionId|
      @char = Character.find_one_by_name(id)
      
      if (!@char)
        flash[:error] = "Character not found."
        redirect '/chars'
      end
      
      @version = ProfileVersion[versionId]     
            
      @page_title = "#{@char.name} - #{game_name}"
      
      erb :"chars/source"
    end
    
    get '/char/:id/compare/:version/?' do |id, versionId|
      @char = Character.find_one_by_name(id)      
      @current = ProfileVersion[versionId]
      
      if (!@char || !@current)
        flash[:error] = "Character version not found!"
        redirect '/chars'
      end
      
      all_versions = @char.profile_versions.to_a.sort_by { |v| v.created_at }
      current_index = all_versions.index { |v| v.id == @current.id }
      if (!current_index || current_index <= 0)
        flash[:error] = "Previous version not found!"
        redirect "/char/#{id}/source/#{versionId}"
      end
      
      @previous = all_versions[current_index - 1]
      
      @page_title = "#{@char.name} - #{game_name}"
      
      @diff = Diffy::Diff.new(@previous.text, @current.text).to_s(:html_simple)
      erb :"chars/compare_profile"
    end
    
  end
end
