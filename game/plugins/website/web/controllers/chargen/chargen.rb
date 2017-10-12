module AresMUSH
  class WebApp

    get '/chargen/?' do      
      if (!@user)
        erb :"chargen/login_required"
      else
        if (@user.is_approved?)
          flash[:error] = "You are already approved."
          redirect char_page_url(@user)
        end

        if (Chargen.check_chargen_locked(@user))
          flash[:error] = "Unsubmit your app (in-game) before making changes."
          redirect char_page_url(@user)
        end

        @factions = Demographics.get_group("Faction")

        @ranks = []
        @factions['values'].each do |k, v|
          @ranks.concat Ranks.allowed_ranks_for_group(k)
        end

        @allowed_ranks = Ranks.allowed_ranks_for_group(@user.group("Faction"))
        template = Chargen::AppTemplate.new(@user, @user)
        @app = ClientFormatter.format template.render, false

        erb :"chargen/chargen"
      end
    end

  end
end
