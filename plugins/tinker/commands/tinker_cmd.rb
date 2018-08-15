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
        mod = 0
        successes = FS3Skills.roll_ability(enactor, "Air")
        client.emit successes
      end



    end
  end
end
