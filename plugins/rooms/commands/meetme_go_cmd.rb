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
          Global.logger.debug "#{enactor_name} joining #{inviter.name} in #{inviter.room.name}."
          Rooms.move_to(client, enactor, inviter.room)
        else
          Global.logger.debug "#{enactor_name} bringing #{inviter.name} to #{enactor_room.name}."
          Rooms.move_to(Login.find_client(inviter), inviter, enactor_room)
        end
      end
    end
  end
end
