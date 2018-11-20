module AresMUSH
  module FS3Combat
    class PoseEventHandler
      def on_event(event)
        enactor = Character[event.enactor_id]
        combatant = enactor.combatant
        room = Room[event.room_id]
        return if !combatant
        return if event.is_ooc
        
        combatant.update(posed: true)
        combat = combatant.combat
        
        set_scene = !combat.scene || combat.scene.completed
        if (set_scene && room.scene)
          combat.update(scene: room.scene)
        end

        slackers = combat.active_combatants.select { |c| !c.is_npc? && !c.posed && !c.is_ko && !c.idle }
        if (slackers.empty? && !combat.everyone_posed)
          FS3Combat.emit_to_organizer combat, t('fs3combat.everyone_posed')
          combat.update(everyone_posed: true)
        end
      end
    end
  end
end