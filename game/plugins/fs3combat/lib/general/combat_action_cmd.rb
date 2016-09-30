module AresMUSH
  module FS3Combat
    class CombatActionCmd
      include CommandHandler
      include CommandRequiresLogin
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name, :action_args, :action_klass
           
      def crack!
        # Command arguments are cracked by the action class.
        self.action_klass = FS3Combat.find_action_klass(cmd.switch)
        return if !self.action_klass
        
        result = self.action_klass.crack_helper(enactor, cmd)
        self.name = result[:name]
        self.action_args = result[:action_args]
      end
    
      def check_noncombatant
        return t('fs3combat.you_are_a_noncombatant') if (enactor.combatant.is_noncombatant? && self.name == enactor_name)
        return nil
      end
      
      def handle
        if (!self.action_klass)
          client.emit_failure t('fs3combat.unknown_command')
          return
        end
        
        FS3Combat.with_a_combatant(self.name, client, enactor) do |combat, combatant|
          FS3Combat.set_action(client, enactor, combat, combatant, self.action_klass, self.action_args)
        end
      end
    end
  end
end