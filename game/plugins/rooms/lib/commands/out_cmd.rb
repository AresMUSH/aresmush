module AresMUSH
  module Rooms
    class OutCmd
      include CommandHandler

      def handle
        exit = enactor_room.way_out
        
        if (!exit || !exit.dest)
          client.emit_failure t("rooms.cant_go_that_way")
          return
        end
        Rooms.move_to(client, enactor, exit.dest)
      end
    end
  end
end
