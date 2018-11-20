
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
        spell = titlecase_arg(cmd.args)
        combatant = enactor.combatant
        weapon = combatant.weapon.before("+")
        special = Global.read_config("spells", spell, "weapon_specials")
        rounds = Global.read_config("spells", spell, "rounds")


        Global.logger.info "Weapon: #{weapon}"
        weapon_specials = combatant.spell_weapon_effects
        Global.logger.info "Combatant's old weapon effects: #{combatant.spell_weapon_effects}"

        if combatant.spell_weapon_effects.has_key?(weapon)
          old_weapon_specials = weapon_specials[weapon]
          weapon_specials[weapon] = old_weapon_specials.merge!( special => rounds)
        else
          weapon_specials[weapon] = {special => rounds}
        end


        combatant.update(spell_weapon_effects: weapon_specials)
        Global.logger.info "Combatant's weapon effects: #{combatant.spell_weapon_effects}"
      end





    end
  end
end

