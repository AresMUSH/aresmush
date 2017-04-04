module AresMUSH
  class WebApp
    get '/chargen' do
      if (!@user)
        flash[:error] = "You need to log in first."
        redirect "/"
      end
        
      
      if (@user.is_approved?)
        flash[:error] = "You are already approved."
        redirect "/char/#{@user.id}"
      end
      
      if (Chargen.check_chargen_locked(@user))
        flash[:error] = "Unsubmit your app before making changes."
        redirect "/char/#{@user.id}"
      end
      
      @factions = Groups.get_group("Faction")
      @positions = Groups.get_group("Position")
      @departments = Groups.get_group("Department")
      @colonies = Groups.get_group("Colony")
      
      @ranks = []
      @factions['values'].each do |k, v|
        @ranks.concat Ranks.allowed_ranks_for_group(k)
      end
      
      @allowed_ranks = Ranks.allowed_ranks_for_group(@user.group_value("Faction"))
      
      
      @fs3_attrs = FS3Skills.attrs
      @fs3_attr_ratings = {
        1 => "Poor", 2 => "Average", 3 => "Good", 4 => "Great", 5 => "Exceptional"
      }
      
      @fs3_action_skills = FS3Skills.action_skills
      @fs3_action_skill_ratings = {
        0 => "Unskilled", 1 => "Everyman", 2 => "Amateur", 3 => "Fair", 4 => "Good",
        5 => "Great", 6 => "Expert", 7 => "Elite", 8 => "Legendary"
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
      
      erb :chargen
    end
    
    post '/chargen', :auth => :user do

      if (@user.is_approved?)
        flash[:error] = "You are already approved."
        redirect "/char/#{@user.id}"
      end
      
      if (Chargen.check_chargen_locked(@user))
        flash[:error] = "Unsubmit your app before making changes."
        redirect "/char/#{@user.id}"
      end
      
      #### ---------------------------------
      #### DEMOGRAPHICS
      #### ---------------------------------
      demo = @user.get_or_create_demographics
      demo.fullname = params[:fullname]
      demo.skin = titlecase_arg(params[:skin])
      demo.hair = titlecase_arg(params[:hair])
      demo.eyes = titlecase_arg(params[:eyes])
      demo.height = titlecase_arg(params[:height])
      demo.physique = titlecase_arg(params[:physique])
      demo.callsign = titlecase_arg(params[:callsign])
      demo.gender = params[:gender]
      demo.actor = params[:actor]
      
      age = params[:age].to_i
      if (!Demographics.check_age(age))
        bday = Date.new ICTime::Api.ictime.year - age, ICTime::Api.ictime.month, ICTime::Api.ictime.day
        bday = bday - rand(364)
        demo.birthdate = bday
      end
      demo.save

      #### ---------------------------------
      #### GROUPS
      #### ---------------------------------

      Groups.set_group(@user, "Faction", params[:faction])
      Groups.set_group(@user, "Department", params[:department])
      Groups.set_group(@user, "Colony", params[:colony])
      Groups.set_group(@user, "Position", params[:position])
      
      @user.update(ranks_rank: params[:rank])
      

      #### ---------------------------------
      #### MISC
      #### ---------------------------------
      
      @user.update(cg_background: format_input_for_mush(params[:background]) )
      Describe.update_current_desc(@user, format_input_for_mush(params[:description]))
      

      #### ---------------------------------
      #### HOOKS
      #### ---------------------------------
      

      remaining_hooks = []
      6.times.each do |i|
        name = titlecase_arg(params["hook-name-#{i}".to_sym])
        desc = params["hook-desc-#{i}".to_sym]  
        if (!desc.empty?)
          remaining_hooks << name
          FS3Skills.set_hook(@user, name, desc)
        end
      end
      @user.fs3_hooks.each do |h|
        if (!remaining_hooks.include?(h.name))
          h.delete
        end
      end
      
      FS3Skills.attrs.each_with_index do |a, i|
        FS3Skills.set_ability(nil, @user, a['name'], params["attr-#{i}".to_sym].to_i)
      end
      
      FS3Skills.action_skills.each_with_index do |a, i|
        FS3Skills.set_ability(nil, @user, a['name'], params["action-#{i}".to_sym].to_i)
      end
      
      remaining_bgskills = []
      10.times.each do |i|
        name = titlecase_arg(params["bg-name-#{i}".to_sym])
        rating = params["bg-rating-#{i}".to_sym].to_i
        remaining_bgskills << name
        
        FS3Skills.set_ability(nil, @user, name, rating)
      end
      @user.fs3_background_skills.each do |h|
        if (!remaining_bgskills.include?(h.name))
          h.delete
        end
      end
      
      fs3_specialties = {}
      FS3Skills.action_skills.select { |a| a['specialties']}.each_with_index do |a, i|
        ability = FS3Skills.find_ability(@user, a['name'])
        specs = params["spec-#{i}".to_sym]
        ability.update(specialties: specs ? specs : [])
      end
      
      FS3Skills.language_names.each_with_index do |a, i|
        FS3Skills.set_ability(nil, @user, a, params["lang-#{i}".to_sym].to_i)
      end
      
      if params[:reset]
        FS3Skills.reset_char(nil, @user)
      end
      
      
  
      redirect "/chargen"
    end
  end
end
