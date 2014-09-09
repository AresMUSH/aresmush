module AresMUSH
  module Rooms
    class OutCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      include PluginWithoutArgs

      def want_command?(client, cmd)
        cmd.root_is?("out")
      end
      
      def handle
        exit = client.room.out_exit
        
        if (exit.nil? || exit.dest.nil?)
          client.emit_failure(t("rooms.cant_go_that_way"))
          return
        end
        Rooms.move_to(client, client.char, exit.dest)
      end
    end
  end
end
