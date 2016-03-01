module AresMUSH
  module Rooms
    class GoCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandRequiresArgs

      attr_accessor :destination
      
      def initialize
        self.required_args = ['destination']
        self.help_topic = 'go'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("go")
      end
      
      def crack!
        self.destination = trim_input(cmd.args)
      end
      
      def handle
        exit = client.room.get_exit(self.destination)
        
        if (exit.nil? || exit.dest.nil?)
          client.emit_failure(t("rooms.cant_go_that_way"))
          return
        end
        
        if (!exit.allow_passage?(client.char))
          client.emit_failure t('rooms.cant_go_through_locked_exit')
          return
        end
        
        Rooms.move_to(client, client.char, exit.dest, exit.name)
      end
    end
  end
end
