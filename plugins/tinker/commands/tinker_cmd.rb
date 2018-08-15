module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler

      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end

      def handle
        Custom.cast_noncombat_spell(enactor, "Create Water")
      end



    end
  end
end
