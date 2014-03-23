module AresMUSH
  module Rooms
    class OpenCmd
      include AresMUSH::Plugin

      attr_accessor :name
      attr_accessor :dest
      
      # Validators
      must_be_logged_in
      no_switches
      argument_must_be_present "name", "open"
      
      def want_command?(client, cmd)
        cmd.root_is?("open")
      end
      
      # TODO - Validate Permissions
      
      def crack!
        cmd.crack!(/(?<name>[^\=]*)=?(?<dest>.*)/)
        self.name = cmd.args.name
        self.dest = cmd.args.dest
      end
      
      def handle
        
        dest = nil
        if (!self.dest.empty?)
          find_result = ClassTargetFinder.find(self.dest, Room)
          if (!find_result.found?)
            client.emit_failure(find_result.error)
            return
          end
          dest = find_result.target
        end
        Rooms.open_exit(self.name, client.room, dest)
      end
    end
  end
end
