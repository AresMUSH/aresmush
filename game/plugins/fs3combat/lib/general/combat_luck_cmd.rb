module AresMUSH
  module FS3Combat
    class CombatLuckCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :reason
      
      def initialize(client, cmd, enactor)
        self.required_args = ['reason']
        self.help_topic = 'combat'
        super
      end
      
      def check_reason
        reasons = ["Initiative", "Attack", "Defense"]
        return t('fs3combat.invalid_luck', :reasons => reasons.join(", ")) if !reasons.include?(self.reason)
        return nil
      end
      
      def check_points
        return t('fs3combat.no_luck') if FS3Skills::Api.luck(enactor) <= 1
        return nil
      end
      
      def crack!
        self.reason = titleize_input(cmd.args)
      end

      def handle
        FS3Combat.with_a_combatant(enactor_name, client) do |combat, combatant|
          
          FS3Skills::Api.spend_luck(enactor, 1)
          enactor.save
          
          combatant.luck = self.reason
          combatant.save
          
          combat.emit t('fs3combat.spending_luck', :name => enactor_name, :reason => self.reason)
        end
      end
    end
  end
end