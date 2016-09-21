module AresMUSH
  module FS3Combat
    class CombatDisembarkCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'combat'
        super
      end
      
      def crack!
        if (cmd.args)
          self.name = titleize_input(cmd.args)
        else
          self.name = client.name
        end
      end

      def handle
        FS3Combat.with_a_combatant(self.name, client) do |combat, combatant|   
          if (!combatant.is_in_vehicle?)
            client.emit_failure t('fs3combat.not_in_vehicle', :name => self.name)
            return
          end
          combat.leave_vehicle(combatant)
          combat.save       
        end
      end
    end
  end
end