module AresMUSH
  module Rooms
    class OutCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandWithoutArgs

      def handle
        exit = enactor_room.way_out
        
        if (exit.nil? || exit.dest.nil?)
          client.emit_failure t("rooms.cant_go_that_way")
          return
        end
        Rooms.move_to(client, enactor, exit.dest)
      end
    end
  end
end
