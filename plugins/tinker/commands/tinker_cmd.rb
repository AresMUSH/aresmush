module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler

      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end

      # def handle
      #   spell = Custom.find_spell_learned(enactor, cmd.args)
      #   spell.delete
      # end

      def handle
        level = Custom.previous_level_spell?(enactor,2)
        client.emit level
      end



    end
  end
end
