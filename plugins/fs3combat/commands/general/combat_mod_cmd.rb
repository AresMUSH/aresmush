module AresMUSH
  module FS3Combat
    class CombatModCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :name, :value, :mod_type
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.value = args.arg2.to_i
        case cmd.switch
        when "defensemod"
          self.mod_type = :defense
        when "lethalmod"
          self.mod_type = :damage
        when "initmod"
          self.mod_type = :initiative
        else
          self.mod_type = :attack
        end
      end

      def required_args
        [ self.name, self.value ]
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
          when :initiative
            combatant.update(initiative_mod: self.value)
          else
            combatant.update(attack_mod: self.value)
          end
          
          client.emit_success t('fs3combat.mod_applied', :name => self.name, :type => self.mod_type)
        end
      end
    end
  end
end