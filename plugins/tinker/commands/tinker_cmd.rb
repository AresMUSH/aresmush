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
        caster_combat = enactor.combatant
        weapon_specials_str = Global.read_config("spells", spell, "weapon_specials")
        weapon_specials = weapon_specials_str ? weapon_specials_str.split('+') : nil
        client.emit weapon_specials
        FS3Combat.set_weapon(enactor, caster_combat, caster_combat.weapon, weapon_specials)
        FS3Combat.emit_to_combat caster_combat.combat, t('custom.casts_spell', :name => caster_combat.name, :spell => spell, :succeeds => "succeeds")
        FS3Combat.set_action(client, caster_combat, caster_combat.combat, caster_combat, FS3Combat::SpellAction, "")







      end



    end
  end
end
