module AresMUSH
  module Rooms
    class HomeCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs

      def check_home_set
        return t('rooms.home_not_set') if enactor.home.nil?
        return nil
      end
      
      def check_can_go_home
        return t('dispatcher.not_allowed') if !Rooms.can_go_home?(enactor)
        return nil
      end
      
      def handle
        char = enactor
        char.room.emit_ooc t('rooms.char_has_gone_home', :name => char.name)
        Rooms.move_to(client, char, char.home)
      end
    end
  end
end
