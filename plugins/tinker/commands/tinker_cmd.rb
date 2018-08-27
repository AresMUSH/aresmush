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

        target_string = cmd.args
        caster = enactor
        spell = "Minor Heal"
        Custom.cast_multi_heal(caster, target_string, spell )
      end



    end
  end
end
