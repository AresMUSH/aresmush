module AresMUSH
  module FS3Combat
    class CombatsRequestHandler
      def handle(request)
        Combat.all.map { |c| {
          id: c.id,
          organizer: c.organizer.name,
          scene: c.scene ? c.scene.id : nil,
          participants: c.combatants.select { |c| !c.is_npc? }.map { |c| c.name }
        }}
      end
    end
  end
end


