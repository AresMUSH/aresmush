module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler

      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end

      def handle
        spell = Custom.find_spell_learned(enactor, cmd.args)
        spell.delete
      end



    end
  end
end
