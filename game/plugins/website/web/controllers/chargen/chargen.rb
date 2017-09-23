module AresMUSH
  class WebApp
    
    get '/chargen/?', :auth => :user do
      
      if (@user.is_approved?)
        flash[:error] = "You are already approved."
        redirect char_page_url(@user)
      end
      
      if (Chargen.check_chargen_locked(@user))
        flash[:error] = "Unsubmit your app (in-game) before making changes."
        redirect char_page_url(@user)
      end
      
      @factions = Demographics.get_group("Faction")
      @positions = Demographics.get_group("Position")
      @departments = Demographics.get_group("Department")
      @colonies = Demographics.get_group("Colony")
      
      @ranks = []
      @factions['values'].each do |k, v|
        @ranks.concat Ranks.allowed_ranks_for_group(k)
      end
      
      @allowed_ranks = Ranks.allowed_ranks_for_group(@user.group("Faction"))
      
      
      @fs3_attrs = FS3Skills.attrs
      @fs3_attr_ratings = {
        1 => "Poor", 2 => "Average", 3 => "Good", 4 => "Great", 5 => "Exceptional"
      }
      
      @fs3_action_skills = FS3Skills.action_skills
      @fs3_action_skill_ratings = {
        1 => "Everyman", 2 => "Fair", 3 => "Competent", 4 => "Good",
        5 => "Great", 6 => "Exceptional", 7 => "Amazing"
      }
      
      @fs3_specialties = {}
      FS3Skills.action_skills.each do |a|
        if (a['specialties']) 
          @fs3_specialties[a['name']] = a['specialties']
        end
      end
      
      @fs3_current_specialties = {}
      @user.fs3_action_skills.each do |a|
        @fs3_current_specialties[a.name] = a.specialties
      end
      
      
      @fs3_bg_skills = {}
            
      @user.fs3_background_skills.each do |b|
        @fs3_bg_skills[b.name] = b.rating
      end
      count = @user.fs3_background_skills.count
      more = [ 1, 10 - count].max
      more.times.each do |m|
        @fs3_bg_skills["skill slot #{m+1}"] = 0
      end
      
      @fs3_bg_skill_ratings = { 
        0 => "Everyman", 1 => "Interest", 2 => "Proficiency", 3 => "Expertise"
      }
      
      @fs3_languages = FS3Skills.language_names
      
      
      @fs3_lang_skill_ratings = { 
        0 => "Everyman", 1 => "Beginner", 2 => "Conversational", 3 => "Fluent"
      }
      
      template = Chargen::AppTemplate.new(@user, @user)
      @app = ClientFormatter.format template.render, false
      
      @hooks = {}
      @user.fs3_hooks.each do |h|
        @hooks[h.name] = h.description
      end
      count = @user.fs3_hooks.count
      more = [ 1, 6 - count].max
      more.times.each do |m|
        @hooks["hook slot #{m+1}"] = ''
      end
      
      erb :"chargen/chargen"
    end
    
  end
end
