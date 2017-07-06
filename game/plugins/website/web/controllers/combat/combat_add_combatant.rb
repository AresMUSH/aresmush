module AresMUSH
  class WebApp

    post '/combat/:id/addcombatant' do |id|
      @combat = Combat[id]
      if (@combat.organizer != @user && !is_admin?)
        flash[:error] = "Only the combat organizer can manage combat."
        redirect "/combat/#{id}"
      end

      name = @params[:name]
      if (name.blank?)
        flash[:error] = "You must specify a combatant name."
        redirect "/combat/#{id}/manage"
      end
      
      combatant = FS3Combat.join_combat(@combat, name, @params[:type], @user, nil)
      if (combatant)
        flash[:info] = "Combatant added!"
      else
        flash[:error] = "There was a problem adding #{name} to the combat."
      end
      
      redirect "/combat/#{id}/manage"
      
    end    
  end
end
