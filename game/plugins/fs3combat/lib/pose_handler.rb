module AresMUSH
  module FS3Combat
    class PoseEventHandler
      def on_event(event)
        enactor = event.enactor
        combatant = enactor.combatant
        return if !combatant
        
        combatant.update(posed: true)
        combat = combatant.combat
        
        slackers = combat.active_combatants.select { |c| !c.is_npc? && !c.posed }
        if (slackers.empty?)
          combat.emit_to_organizer t('fs3combat.everyone_posed')
        end
      end
    end
  end
end