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
          combat.active_combatants.select { |c| c.is_npc? && !c.action }.each_with_index do |c, i|
            FS3Combat.ai_action(combat, client, c)
          end
          combat.emit t('fs3combat.new_turn', :name => enactor_name)
          combat.update(first_turn: false)
          return
        end
        
        initiative_order = FS3Combat.get_initiative_order(combat)
        
        combat.emit t('fs3combat.starting_turn_resolution', :name => enactor_name)
        combat.update(turn_in_progress: true)
        
        initiative_order.each_with_index do |c, i|
          Global.dispatcher.queue_timer(i, "Combat Turn", client) do
            next if !c.action
            next if c.is_noncombatant?

            Global.logger.debug "Action #{c.name} #{c.action ? c.action.print_action_short : "-"} #{c.is_noncombatant?}"
          
            messages = c.action.resolve
            messages.each do |m|
              Global.logger.debug "#{m}"
              combat.emit m
            end
          end
        end
        
        Global.dispatcher.queue_timer(initiative_order.count + 2, "Combat Turn", client) do
          initiative_order.each { |c| FS3Combat.reset_for_new_turn(c) }
          combat.update(turn_in_progress: false)
          combat.emit t('fs3combat.new_turn', :name => enactor_name)
        end
      end
    end
  end
end