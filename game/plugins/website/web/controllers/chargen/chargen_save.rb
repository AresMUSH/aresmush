module AresMUSH
  class WebApp
    
    post '/chargen', :auth => :user do

      if (@user.is_approved?)
        flash[:error] = "You are already approved."
        redirect char_page_url(@user)
      end
            
      if (Chargen.check_chargen_locked(@user))
        flash[:error] = "Unsubmit your app (in-game) before making changes."
        redirect char_page_url(@user)
      end
      
      #### ---------------------------------
      #### DEMOGRAPHICS
      #### ---------------------------------

      @user.update_demographic :fullname, params[:fullname]
      @user.update_demographic :skin, titlecase_arg(params[:skin])
      @user.update_demographic :hair, titlecase_arg(params[:hair])
      @user.update_demographic :eyes, titlecase_arg(params[:eyes])
      @user.update_demographic :height, titlecase_arg(params[:height])
      @user.update_demographic :physique, titlecase_arg(params[:physique])
      @user.update_demographic :callsign, titlecase_arg(params[:callsign])
      @user.update_demographic :gender, params[:gender]
      @user.update_demographic :actor, params[:actor]
      
      age = params[:age].to_i
      if (!Demographics.check_age(age))
        bday = Date.new ICTime.ictime.year - age, ICTime.ictime.month, ICTime.ictime.day
        bday = bday - rand(364)
        @user.update_demographic :birthdate, bday
      end

      #### ---------------------------------
      #### GROUPS
      #### ---------------------------------

      Demographics.set_group(@user, "Faction", params[:faction])
      Demographics.set_group(@user, "Department", params[:department])
      Demographics.set_group(@user, "Colony", params[:colony])
      Demographics.set_group(@user, "Position", params[:position])
      
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
      
      
      if (params['submit-app'])
        Chargen.submit_app(@user)
        flash[:info] = "Your application has been submitted.  You must log into the game to check on its status."
        redirect char_page_url(@user)
      end
        
      redirect "/chargen?tab=#{params[:tab] || 'abilities'}"
    end
  end
end
