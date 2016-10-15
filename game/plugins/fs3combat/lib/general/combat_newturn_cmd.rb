module AresMUSH
  module FS3Combat
    class CombatNewTurnCmd
      include CommandHandler
      include CommandRequiresLogin
      include NotAllowedWhileTurnInProgress

      def handle
        if (!enactor.is_in_combat?)
          client.emit_failure t('fs3combat.you_are_not_in_combat')
          return
        end
                
        combat = enactor.combatant.combat
        
        if (combat.organizer != enactor)
          client.emit_failure t('fs3combat.only_organizer_can_do')
          return
        end
                
        Global.logger.debug "****** NEW COMBAT TURN ******"

        if (combat.first_turn)
          combat.active_combatants.select { |c| c.is_npc? }.each_with_index do |c, i|
            Global.dispatcher.queue_timer(i, "Combat AI", client) do          
              FS3Combat.ai_action(combat, client, c)
            end
          end
          combat.emit t('fs3combat.new_turn', :name => enactor_name)
          combat.first_turn = false
          combat.save
          return
        end
        
        initiative_order = FS3Combat.roll_initiative(combat)
        
        combat.emit t('fs3combat.starting_turn_resolution', :name => enactor_name)
        combat.turn_in_progress = true
        combat.save
        
        initiative_order.each_with_index do |c, i|
          Global.dispatcher.queue_timer(i, "Combat Turn", client) do
            
            Global.logger.debug "Action #{c.name} #{c.action ? c.action.print_action_short : "-"} #{c.is_noncombatant?}"
            
            next if !c.action
            next if c.is_noncombatant?
          
            messages = c.action.resolve
            messages.each do |m|
              Global.logger.debug "#{m}"
              combat.emit m
            end
             
            # Reset aim if they've done anything other than aiming. 
            # TODO - Better way of doing this.
            # TODO - Reset action if out of ammo.
            # TODO - Reset action if target no longer exists.
            if (c.is_aiming && c.action.class != AimAction)
              Global.logger.debug "Reset aim for #{c.name}."
              c.is_aiming = false
            end
          
            c.posed = false
            c.recoil = 0
          end
        end
        
        Global.dispatcher.queue_timer(initiative_order.count + 1, "Combat Turn", client) do
          initiative_order.each do |c|
            c.save
          end
          combat.turn_in_progress = false
          combat.save
          combat.emit t('fs3combat.new_turn', :name => enactor_name)
        end
      end
    end
  end
end