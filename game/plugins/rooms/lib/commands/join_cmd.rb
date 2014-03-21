module AresMUSH
  module Rooms
    class JoinCmd
      include AresMUSH::Plugin

      attr_accessor :target
      
      # Validators
      must_be_logged_in
      no_switches
      argument_must_be_present "target", "join"
      
      def want_command?(client, cmd)
        cmd.root_is?("join")
      end
      
      def crack!
        self.target = trim_input(cmd.args)
      end
      
      # TODO - Permissions
      
      def handle
        find_result = SingleTargetFinder.find(self.target, Character)
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        Rooms.move_to(client, find_result.target.room)
      end
    end
  end
end
