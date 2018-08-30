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
        char = enactor
        school = "Fire"
        mod = 0

        roll = char.roll_ability(school, mod)
        client.emit roll[:successes]
        target_name = cmd.args
        target = FS3Combat.find_named_thing(target_name, enactor)
      

        Custom.cast_non_combat_heal(enactor, target, "Minor Heal")


        # target_string = cmd.args
        # caster = enactor
        # spell = "Minor Heal"
        # Custom.cast_multi_heal(caster, target_string, spell )
      end





    end
  end
end
