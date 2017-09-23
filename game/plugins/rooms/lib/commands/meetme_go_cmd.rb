module AresMUSH
  module Rooms
    class MeetmeGoCmd
      include CommandHandler
      
      attr_accessor :going
      
      def parse_args
        self.going = cmd.switch_is?("join")
      end
      
      def check_meetme
        return t('rooms.no_meetme_invite') if client.program[:meetme].nil?
        return nil
      end
      
      def handle
        inviter = Character[client.program[:meetme]]
        if (self.going)
          Rooms.move_to(client, enactor, inviter.room)
        else
          Rooms.move_to(inviter.client, inviter, enactor_room)
        end
      end
    end
  end
end
