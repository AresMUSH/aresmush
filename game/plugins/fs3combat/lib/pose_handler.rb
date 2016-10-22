module AresMUSH
  module FS3Combat
    class PoseEventHandler
      def on_event(event)
        enactor = event.enactor
        return if !enactor.combatant
        enactor.combatant.update(posed: true)
      end
    end
  end
end