module AresMUSH
  module Rooms
    class HomeSetCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs

      def want_command?(client, cmd)
        cmd.root_is?("home") && cmd.switch_is?("set")
      end
      
      def check_can_go_home
        return t('dispatcher.not_allowed') if !Rooms.can_go_home?(client.char)
        return nil
      end
      
      def handle
        client.emit_ooc t('rooms.home_set')
        client.char.home = client.char.room
        client.char.save!
      end
    end
  end
end
