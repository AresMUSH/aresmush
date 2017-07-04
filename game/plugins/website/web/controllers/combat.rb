module AresMUSH
  class WebApp
    
    helpers do
      def combatants_by_team(combat)
        combat.active_combatants.sort_by{|c| c.team}.group_by {|c| c.team}
      end
    end
    
    get '/combat' do
      @combats = Combat.all
      erb :"combat/index"
    end
    
    get '/combat/:id' do |id|
      @combat = Combat[id]
      erb :"combat/combat"
    end
    
    get '/combat/:id/manage' do |id|
      @combat = Combat[id]
      if (@combat.organizer != @user && !is_admin?)
        flash[:error] = "Only the combat organizer can manage combat."
        redirect "/combat/#{id}"
      end
      
      erb :"combat/manage"
    end
    
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
    
    post '/combat/:id/update' do |id|
      @combat = Combat[id]
      if (@combat.organizer != @user && !is_admin?)
        flash[:error] = "Only the combat organizer can manage combat."
        redirect "/combat/#{id}"
      end

      errors = []
      
      @combat.active_combatants.each do |c|
        team = @params["#{c.id}-team"].to_i
        stance = @params["#{c.id}-stance"]
        weapon = @params["#{c.id}-weapon"]
        selected_specials = @params["#{c.id}-weaponspec"] || []
        armor = @params["#{c.id}-armor"]
        armor = armor == "None" ? nil : armor
        npc = @params["#{c.id}-npc"]

        if (team != c.team)
          c.update(team: team)
          @combat.emit "#{c.name} is now on Team #{team}. (by #{@user.name})"
        end
        
        if (stance != c.stance)
          c.update(stance: stance)
          @combat.emit "#{c.name} has changed stance to #{stance}. (by #{@user.name})"
        end
        
        old_weapon = c.weapon
        
        if (weapon != c.weapon_name)
          c.update(weapon_name: weapon)
        end

        allowed_specials = FS3Combat.weapon_stat(c.weapon, "allowed_specials") || []
        weapon_specials = []
        selected_specials.each do |w|
          if (!allowed_specials.include?(w))
            errors << "#{w} is not an allowed special for #{c.name}'s #{weapon}."
          else
            weapon_specials << w
          end
        end
        c.update(weapon_specials: weapon_specials)

        if (old_weapon != c.weapon)
          @combat.emit "#{c.name} has changed weapons to #{c.weapon}. (by #{@user.name})"
        end
        
        if (armor != c.armor)
          c.update(armor: armor)
          @combat.emit "#{c.name} has changed armor to #{c.armor}. (by #{@user.name})"
        end
        
        if (c.is_npc? && c.npc.level != npc)
          c.npc.update(level: npc)
        end

      end
      
      if (errors.any?)
        flash[:error] = "Combat updaed, but there were some problems:<br/>- #{errors.join("<br/>- ")}"
      else
        flash[:info] = "Combat updated."
      end
      redirect "/combat/#{id}/manage"
    end
  end
end
