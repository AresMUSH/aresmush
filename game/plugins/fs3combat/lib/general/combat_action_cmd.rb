module AresMUSH
  module FS3Combat
    class CombatActionCmd
      include CommandHandler
      include CommandRequiresLogin
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name, :action_args, :action_klass
      
      def want_command?(client, cmd)
        return false if !cmd.root_is?("combat")
        self.action_klass = FS3Combat.find_action_klass(cmd.switch)
        return !self.action_klass.nil?
      end
      
      def crack!
        # Command arguments are cracked by the action class.
        result = self.action_klass.crack_helper(client, cmd)
        self.name = result[:name]
        self.action_args = result[:action_args]
      end
      
    
      def check_noncombatant
        return t('fs3combat.you_are_a_noncombatant') if (client.char.combatant.is_noncombatant? && self.name == client.name)
        return nil
      end
      
      def handle
        FS3Combat.with_a_combatant(self.name, client) do |combat, combatant|
          FS3Combat.set_action(client, combat, combatant, self.action_klass, self.action_args)
        end
      end
    end
  end
end