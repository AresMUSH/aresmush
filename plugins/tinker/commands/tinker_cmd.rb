<<<<<<< HEAD
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

        combatant = enactor.combatant
        combatant.character.update(dead: true )
        client.emit combatant.character.dead
      end







    end
  end
end
=======
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








    end
  end
end
>>>>>>> 0365a55d80ffbce4e4628205a2aa8e4c94ae3036
