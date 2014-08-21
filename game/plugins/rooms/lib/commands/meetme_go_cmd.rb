module AresMUSH
  module Rooms
    class MeetmeGoCmd
      include Plugin
      include PluginRequiresLogin
      
      attr_accessor :going
      
      def want_command?(client, cmd)
        cmd.root_is?("meetme") && (cmd.switch_is?("join") || cmd.switch_is?("bring"))
      end
      
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
