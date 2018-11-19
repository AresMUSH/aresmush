
module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
        attr_accessor :name, :armor, :specials
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end





      def handle
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        weapon = titlecase_arg(args.arg1)
        special = titlecase_arg(args.arg2)
        rounds = 3
        combatant = enactor.combatant

        weapon_specials = combatant.spell_weapon_effects
        client.emit weapon_specials

        if combatant.spell_weapon_effects.has_key?(weapon)
          old_weapon_specials = weapon_specials[weapon]
          client.emit old_weapon_specials
          weapon_specials[weapon] = old_weapon_specials.merge!( special => rounds)
        else
          weapon_specials[weapon] = {special => rounds}
        end


        combatant.update(spell_weapon_effects: weapon_specials)
        client.emit  combatant.spell_weapon_effects
      end





    end
  end
end
