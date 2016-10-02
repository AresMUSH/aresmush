module AresMUSH
  module FS3Combat
    class PoseEventHandler
      def on_event(event)
        enactor = event.enactor
        return if !enactor.combatant
        enactor.combatant.posed = true
        enactor.combatant.save
      end
    end
  end
end