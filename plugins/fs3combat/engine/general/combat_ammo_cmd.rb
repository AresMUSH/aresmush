module AresMUSH
  module FS3Combat
    class CombatAmmoCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :ammo, :name
      
      def parse_args
        if (cmd.args =~ /\=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.name = titlecase_arg(args.arg1)
          self.ammo = integer_arg(args.arg2)
        else
          self.name = enactor_name
          self.ammo = integer_arg(cmd.args)
        end
        self.ammo = [ 0, self.ammo ].max
      end

      def required_args
        [ self.ammo ]
      end
      
      
      def handle
        FS3Combat.with_a_combatant(self.name, client, enactor) do |combat, combatant|
          
          combatant.update(ammo: self.ammo)
          FS3Combat.emit_to_combat combat, t('fs3combat.ammo_set', :name => self.name, :ammo => self.ammo)
        end
      end
    end
  end
end