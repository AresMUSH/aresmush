module AresMUSH
  module FS3Combat
    class CombatStanceCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name, :stance
      
      def crack!
        if (cmd.args =~ /=/)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2)
          self.name = titleize_input(cmd.args.arg1)
          self.stance = titleize_input(cmd.args.arg2)
        else
          self.name = enactor.name
          self.stance = titleize_input(cmd.args)
        end
      end

      def required_args
        {
          args: [ self.name, self.stance ],
          help: 'combat'
        }
      end

      def check_stance
        stances = ['Banzai', 'Normal', 'Cautious', 'Evade', 'Cover']
        return t('fs3combat.invalid_stance') if !stances.include?(self.stance)
        return nil
      end
      
      def handle
        FS3Combat.with_a_combatant(name, client, enactor) do |combat, combatant|        
          combatant.stance = stance
          combatant.save
          message = t('fs3combat.stance_changed', :stance => self.stance, :name => self.name, :poss => combatant.poss_pronoun)
          combat.emit message, FS3Combat.npcmaster_text(name, enactor)
        end
      end
    end
  end
end