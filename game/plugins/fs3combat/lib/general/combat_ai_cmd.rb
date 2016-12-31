module AresMUSH
  module FS3Combat
    class CombatAiCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :force, :names
      
      def crack!
       self.force = (cmd.args && cmd.args.downcase == "force")
       self.names = (!self.force && cmd.args) ? cmd.args.split(" ").map { |n| titleize_input(n) } : nil
     end
     
      def check_in_combat
        return t('fs3combat.you_are_not_in_combat') if !enactor.is_in_combat?
        return nil
      end
      
      def handle
        combat = enactor.combat
        
        if (combat.organizer != enactor)
          client.emit_failure t('fs3combat.only_organizer_can_do')
          return
        end

        if (self.force)
          npcs = combat.active_combatants.select { |c| c.is_npc? }
        elsif (self.names)
          npcs = []
          self.names.each do |name|
            combatant = combat.find_combatant(name)
      
            if (!combatant)
              client.emit_failure t('fs3combat.not_in_combat', :name => name)
              return
            end
            npcs << combatant
          end
        else
          npcs = combat.active_combatants.select { |c| c.is_npc? && !c.action }
        end
        
        if (npcs.empty?)
          client.emit_failure t('fs3combat.no_ai_actions_to_set')
          return
        end
        
        client.emit_success t('fs3combat.choosing_ai_actions')
        
        npcs.each_with_index do |c, i|
          FS3Combat.ai_action(combat, client, c)
        end
      end
    end
  end
end