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

      def setup_awards(char)
        medals = char.awards.to_a

        campaign = medals.select { |a| a.award =~ /Campaign Medal/ }
        campaign.each { |c| medals.delete(c) }

        badges = medals.select { |a| a.award =~ /(Badge|Wings)/ }
        badges.each { |b| medals.delete(b) }
        badge_names = badges.map { |b| b.award }
        badge_display = []

        if (char.group("Department") == "Marines")
          badge_names << "Colonial Warrior Badge"
        end

        if (char.group("Department") == "Air Wing")
          badge_names << "Pilot Wings"
        end

        if (char.group("Position") == "Raptor ECO")
          badge_names << "Electronic Warfare Badge"
        end

        [ "Pilot Wings", "Electronic Warfare Badge", "Colonial Warrior Badge" ].each do |name|
          [ "Master ", "Expert ", "" ].each do |level|
            fullname = "#{level}#{name}"
            if badge_names.include?(fullname)
              badge_display << fullname
              break
            end
          end
        end

        [ "Sniper Badge", "Expert Marksman Badge", "Marksman Badge" ].each do |w|
          if badge_names.include?(w)
            badge_display << w
            break
          end
        end

        [ "Combat Medical Badge", "Aerospace Combat Badge", "Ground Combat Badge" ].each do |name|
          [ "Gold ", "" ].each do |level|
            fullname = "#{level}#{name}"
            if badge_names.include?(fullname)
              badge_display << fullname
              break
            end
          end
        end

        sac = 0
        if (char.damage.count > 0)
          last_award_ceremony = "2237-07-27"
          prior_damage = char.damage.select { |d| DateTime.strptime(d.ictime_str, '%m/%d/%Y') < DateTime.parse(last_award_ceremony) }
          sac = prior_damage.group_by { |d| d.ictime_str }.count
        end

        award_priorities = [ "Legion Of Kobol", "Phoenix Cross", "Silver Cluster", "Distinguished Marine Medal", "Distinguished Navy Medal", "Distinguished Aerospace Medal" ]

        @campaign_images = campaign.map { |c| "#{c.award.downcase.gsub(" ", "-")}.png" }
        @medal_images = medals.group_by { |m| m.award }
           .sort_by { |name, awards| award_priorities.index(name) || 9 }
           .map { |name, awards| "#{name}#{awards.count > 1 ? awards.count : '' }.png".downcase.gsub(" ", "-") }
        @medal_images << "meritorious-unit-citation.png"
        @badge_images = badge_display.map { |b| "#{b}.png".downcase.gsub(" ", "-") }

        if ( sac > 0)
          if (sac > 16)
            n = sac / 16
            n.times.each { |x| @medal_images << "sacrifice16.png" }
            sac = sac - (n * 16)
          end

          @medal_images << "sacrifice#{sac}.png"
        end
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

      setup_awards(@char)

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
      
      @page_title = "#{@char.name} - #{game_name}"
      
      erb :"chars/source"
    end
  end
end
