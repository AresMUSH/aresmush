module AresMUSH
  module ExpandedMounts
    class CombatExpandedMountsCmd
      include CommandHandler
      
      def check_in_combat
        return t('fs3combat.you_are_not_in_combat') if !enactor.is_in_combat?
        return nil
      end
      
      def handle
        combat = enactor.combat
        template = CombatExpandedMountsTemplate.new(combat)
        client.emit template.render
      end
    end
  end
end