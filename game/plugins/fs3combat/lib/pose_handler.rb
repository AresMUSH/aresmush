module AresMUSH
  module FS3Combat
    class PoseEventHandler
      def on_event(event)
        char = event.client.char
        return if !char.combatant
        char.combatant.posed = true
        char.combatant.save
      end
    end
  end
end