module AresMUSH
  module FS3Combat
    class CombatAiCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :force, :names
      
      def parse_args
       self.force = (cmd.args && cmd.args.downcase == "force")
       self.names = (!self.force && cmd.args) ? cmd.args.split(" ").map { |n| titlecase_arg(n) } : nil
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

        client.emit_success t('fs3combat.choosing_ai_actions')

        if (self.force)
          npcs = combat.active_combatants.select { |c| c.is_npc? }
          
        elsif (self.names)
          npcs = []
          self.names.each do |raw_name|
            name = raw_name.before(":")
            target = raw_name.after(":")
            
            combatant = combat.find_combatant(name)
      
            if (!combatant)
              client.emit_failure t('fs3combat.not_in_combat', :name => name)
              next
            end
            
            if (!target.blank?)
              error = FS3Combat.set_action(enactor, combat, combatant, FS3Combat::AttackAction, target)
              if (error)
                client.emit_failure error
              end
            else
              npcs << combatant
            end
          end
          
        else
          npcs = combat.active_combatants.select { |c| c.is_npc? && !c.action }
        end
                
        npcs.each_with_index do |c, i|
          FS3Combat.ai_action(combat, c, enactor)
        end
      end
    end
  end
end