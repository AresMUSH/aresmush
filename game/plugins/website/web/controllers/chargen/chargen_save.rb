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
      #### MISC
      #### ---------------------------------

      @user.update(cg_background: format_input_for_mush(params[:background]) )
      Describe.update_current_desc(@user, format_input_for_mush(params[:description]))



      redirect "/chargen?tab=#{params[:tab] || 'background'}"
    end
  end
end
