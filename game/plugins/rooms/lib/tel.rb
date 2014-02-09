module AresMUSH
  module Rooms
    class Tel
      include AresMUSH::Plugin

      def want_command?(cmd)
        cmd.logged_in? && cmd.root_is?("tel")
      end
      
      def on_command(client, cmd)
        dest = cmd.args
        find_result = SingleTargetFinder.find(dest, Room)
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        room = find_result.target        
        client.emit_success("You teleport to #{room["name"]}.")
        client.char.room = room
        client.char.save!
        client.emit Describe.format_room_desc(room)
      end
    end
  end
end
