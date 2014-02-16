module AresMUSH
  module Rooms
    class Build
      include AresMUSH::Plugin

      def want_command?(client, cmd)
        client.logged_in? && cmd.root_is?("build")
      end
      
      def on_command(client, cmd)
        name = cmd.args
        room = Room.create("name" => name)
        client.emit_success("You build a room named #{name}.  ID: #{room["_id"]}")
      end
    end
  end
end
