
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
        roll = enactor.combatant.roll_ability("Fire")
        client.emit roll
        roll2 = enactor.roll_ability("Fire")
        client.emit roll2[:successes]
        client.emit roll2
      end




    end
  end
end
