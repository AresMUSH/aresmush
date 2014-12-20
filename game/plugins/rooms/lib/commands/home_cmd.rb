module AresMUSH
  module Rooms
    class HomeCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs

      def want_command?(client, cmd)
        cmd.root_is?("home") && cmd.switch.nil?
      end
      
      def check_home_set
        return t('rooms.home_not_set') if client.char.home.nil?
        return nil
      end
      
      def check_can_go_home
        return t('dispatcher.not_allowed') if !Rooms.can_go_home?(client.char)
        return nil
      end
      
      def handle
        char = client.char
        char.room.emit_ooc t('rooms.char_has_gone_home', :name => char.name)
        Rooms.move_to(client, char, char.home)
      end
    end
  end
end
