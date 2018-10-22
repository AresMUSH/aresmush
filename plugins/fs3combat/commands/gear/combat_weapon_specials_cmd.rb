module AresMUSH
  module FS3Combat
    class WeaponSpecialsCmd
      #combat/weaponspecials <name>=<specials>
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      attr_accessor :target_name, :target_combat, :specials_str, :specials

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        combat = enactor.combat
        self.target_name = args.arg1
        self.target_combat = combat.find_combatant(self.target_name)
        self.specials_str = titlecase_arg(args.arg2)
        self.specials = specials_str ? specials_str.split('+') : nil
      end

      def check_can_set
        return t('dispatcher.not_allowed') if !enactor.has_permission?("manage_combat")
      end

      def check_errors
        return t('custom.invalid_name') if !target_combat
      end

      def handle
        client.emit self.specials_str
        if self.specials_str == "None"
          target_combat.update(spell_weapon_specials: [])
          client.emit_success t('custom.updated_weapon_specials', :target => target_combat.name, :specials => "None")
        else
          target_combat.update(spell_weapon_specials: specials ? specials.map { |s| s.titlecase }.uniq : [])
          client.emit_success t('custom.updated_weapon_specials', :target => target_combat.name, :specials => target_combat.spell_weapon_specials.join(", "))
        end
      end



    end
  end
end
