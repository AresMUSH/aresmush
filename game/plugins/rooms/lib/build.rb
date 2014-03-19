module AresMUSH
  module Rooms
    class BuildCmd
      include AresMUSH::Plugin

      attr_accessor :name
      
      # Validators
      must_be_logged_in
      no_switches
      argument_must_be_present "name", "build"
      
      def want_command?(client, cmd)
        cmd.root_is?("build")
      end
      
      def crack!
        self.name = cmd.args
      end

      # TODO - Validate permissions
      
      def handle
        room = AresMUSH::Room.create(:name => name)
        client.emit_success("You build a room named #{name}.  ID: #{room["_id"]}")
        Rooms.move_to(client, room)
        
      end
    end
  end
end
