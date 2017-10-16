module AresMUSH
  module FS3Combat
    class CombatTypesCmd
      include CommandHandler
      
      def handle
        template = CombatTypesTemplate.new(FS3Combat.combatant_types)
        client.emit template.render
      end        
    end
  end
end