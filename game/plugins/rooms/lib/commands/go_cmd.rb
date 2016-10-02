module AresMUSH
  module Rooms
    class GoCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandRequiresArgs

      attr_accessor :destination
      
      def crack!
        self.destination = trim_input(cmd.args)
      end
      
      def required_args
        {
          args: [ self.destination ],
          help: 'go'
        }
      end
      
      def handle
        exit = enactor_room.get_exit(self.destination)
        
        if (!exit || !exit.dest)
          client.emit_failure(t("rooms.cant_go_that_way"))
          return
        end
        
        if (!Rooms::Api.can_use_exit?(exit, enactor))
          client.emit_failure t('rooms.cant_go_through_locked_exit')
          return
        end
        
       Rooms.move_to(client, enactor, exit.dest, exit.name)
      end
    end
  end
end
