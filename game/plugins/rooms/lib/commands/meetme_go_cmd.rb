module AresMUSH
  module Rooms
    class MeetmeGoCmd
      include CommandHandler
      include CommandRequiresLogin
      
      attr_accessor :going
      
      def crack!
        self.going = cmd.switch_is?("join")
      end
      
      def check_meetme
        return t('rooms.no_meetme_invite') if client.program[:meetme].nil?
        return nil
      end
      
      def handle
        inviter = client.program[:meetme]
        if (self.going)
          Rooms.move_to(client, client.char, inviter.room)
        else
          Rooms.move_to(inviter, inviter.char, client.room)
        end
      end
    end
  end
end
