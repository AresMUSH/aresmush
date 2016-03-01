module AresMUSH
  module Rooms
    class OutCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandWithoutArgs

      def want_command?(client, cmd)
        cmd.root_is?("out")
      end
      
      def handle
        exit = client.room.way_out
        
        if (exit.nil? || exit.dest.nil?)
          client.emit_failure t("rooms.cant_go_that_way")
          return
        end
        Rooms.move_to(client, client.char, exit.dest)
      end
    end
  end
end
