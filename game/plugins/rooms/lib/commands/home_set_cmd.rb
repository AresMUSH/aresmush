module AresMUSH
  module Rooms
    class HomeSetCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      
      def check_can_go_home
        return t('dispatcher.not_allowed') if !Rooms.can_go_home?(client.char)
        return nil
      end
      
      def handle
        client.emit_ooc t('rooms.home_set')
        client.char.home = client.char.room
        client.char.save
      end
    end
  end
end
