module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler

      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end

      def handle
        enactor.combatant.update(has_cast: false)
      end

      def handle
        school = cmd.args
        successes = Custom.roll_combat_spell(enactor, enactor.combatant, cmd.args)
        client.emit successes
        # client.emit die_result
        client.emit school
      end

    end
  end
end
