module AresMUSH
  module FS3Combat
    class CombatActionCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name, :action_args, :combat_command
           
      def crack!
        if (cmd.args =~ /\=/)
          self.name = InputFormatter.titleize_input(cmd.args.before("="))
          self.action_args = cmd.args.after("=")
        else
          self.name = enactor.name
          self.action_args = cmd.args
        end
        self.combat_command = cmd.switch ? cmd.switch.downcase : nil
      end
      
      def check_can_act
        return t('fs3combat.you_are_not_in_combat') if !enactor.is_in_combat?
        return t('fs3combat.cannot_act_while_koed') if (enactor.combatant.is_ko && self.name == enactor.name)
        return t('fs3combat.you_are_a_noncombatant') if (enactor.combatant.is_noncombatant? && self.name == enactor_name)
        return nil
      end
      
      def handle
        action_klass = FS3Combat.find_action_klass(self.combat_command)
        if (!action_klass)
          client.emit_failure t('fs3combat.unknown_command')
          return
        end
        
        if (enactor.combatant.is_subdued? && self.combat_command != "escape")
          client.emit_failure t('fs3combat.must_escape_first') 
          return
        end
        
        FS3Combat.with_a_combatant(self.name, client, enactor) do |combat, combatant|
          FS3Combat.set_action(client, enactor, combat, combatant, action_klass, self.action_args)
        end
      end
    end
  end
end