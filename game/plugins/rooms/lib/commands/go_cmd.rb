module AresMUSH
  module Rooms
    class GoCmd
      include CommandHandler

      attr_accessor :destination
      
      def parse_args
        self.destination = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.destination ]
      end
      
      def handle
        exit = enactor_room.get_exit(self.destination)
        
        if (!exit || !exit.dest)
          client.emit_failure(t("rooms.cant_go_that_way"))
          return
        end
        
        if (!exit.allow_passage?(enactor))
          client.emit_failure t('rooms.cant_go_through_locked_exit')
          return
        end
        
       Rooms.move_to(client, enactor, exit.dest, exit.name)
      end
    end
  end
end
