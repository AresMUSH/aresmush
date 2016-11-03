module AresMUSH
  module FS3Combat
    class CombatModCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name, :value, :mod_type
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.value = cmd.args.arg2.to_i
        case cmd.switch
        when "defensemod"
          self.mod_type = :defense
        when "lethalmod"
          self.mod_type = :damage
        else
          self.mod_type = :attack
        end
      end

      def required_args
        {
          args: [ self.name, self.value ],
          help: 'combat org'
        }
      end
      
      def handle
        FS3Combat.with_a_combatant(self.name, client, enactor) do |combat, combatant|
          
          if (combat.organizer != enactor)
            client.emit_failure t('fs3combat.only_organizer_can_do')
            return
          end

          case self.mod_type
          when :defense
            combatant.update(defense_mod: self.value)
          when :damage
            combatant.update(damage_lethality_mod: self.value)
          else
            combatant.update(attack_mod: self.value)
          end
          
          client.emit_success t('fs3combat.mod_applied', :name => self.name, :type => self.mod_type)
        end
      end
    end
  end
end