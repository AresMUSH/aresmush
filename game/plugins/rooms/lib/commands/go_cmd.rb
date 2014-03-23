module AresMUSH
  module Rooms
    class GoCmd
      include AresMUSH::Plugin

      attr_accessor :destination
      
      # Validators
      must_be_logged_in
      no_switches
      argument_must_be_present "destination", "go"
      
      def want_command?(client, cmd)
        cmd.root_is?("go")
      end
      
      def crack!
        self.destination = trim_input(cmd.args)
      end
      
      # TODO - Permissions
      
      def handle
        exit = client.room.exits.find_by_name_upcase(self.destination.upcase)
        
        if (exit.nil? || exit.dest.nil?)
          client.emit_failure(t("rooms.cant_go_that_way"))
          return
        end
        Rooms.move_to(client, client.char, exit.dest)
      end
    end
  end
end
