module AresMUSH
  module FS3Combat
    class CombatNewTurnCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress

      def handle
        if (!enactor.is_in_combat?)
          client.emit_failure t('fs3combat.you_are_not_in_combat')
          return
        end

        combat = enactor.combat

        if (combat.organizer != enactor && !enactor.is_admin?)
          client.emit_failure t('fs3combat.only_organizer_can_do')
          return
        end

        combat.log "****** NEW COMBAT TURN ******"
        Global.logger.info "Enactor Combatant's weapon effects at start of turn: #{enactor.combatant.spell_weapon_effects}"

        if (combat.first_turn)
          combat.active_combatants.select { |c| c.is_npc? && !c.action }.each_with_index do |c, i|
            FS3Combat.ai_action(combat, client, c)
          end
          FS3Combat.emit_to_combat combat, t('fs3combat.new_turn', :name => enactor_name)
          combat.update(first_turn: false)
          return
        end
        Global.logger.info "Enactor Combatant's weapon effects before starting resolutions: #{enactor.combatant.spell_weapon_effects}"
        FS3Combat.emit_to_combat combat, t('fs3combat.starting_turn_resolution', :name => enactor_name)

        combat.update(turn_in_progress: true)
        combat.update(everyone_posed: false)

        Global.dispatcher.spawn("Combat Turn", client) do
          begin
            initiative_order = FS3Combat.get_initiative_order(combat)

            initiative_order.each do |id|
              c = Combatant[id]
              next if !c.action
              next if c.is_noncombatant?

              combat.log "Action #{c.name} #{c.action ? c.action.print_action_short : "-"} #{c.is_noncombatant?}"
              Global.logger.info "Enactor Combatant's weapon effects mid resolutions: #{enactor.combatant.spell_weapon_effects}"
              messages = c.action.resolve
              Global.logger.info "Enactor Combatant's weapon effects mid resolutions2: #{enactor.combatant.spell_weapon_effects}"
              messages.each do |m|
                FS3Combat.emit_to_combat combat, m, nil, true
              end
              Global.logger.info "Enactor Combatant's weapon effects mid resolutions3: #{enactor.combatant.spell_weapon_effects}"

            end
            Global.logger.info "Enactor Combatant's weapon effects at end of resolutions: #{enactor.combatant.spell_weapon_effects}"
            combat.log "---- Resolutions ----"

            combat = enactor.combat
            combat.active_combatants.each { |c| FS3Combat.reset_for_new_turn(c) }
            # This will reset their action if it's no longer valid.  Do this after everyone's been KO'd.
            combat.active_combatants.each { |c| c.action }

            FS3Combat.emit_to_combat combat, t('fs3combat.new_turn', :name => enactor_name)
          ensure
            combat.update(turn_in_progress: false)
          end
        end
      end
    end
  end
end
