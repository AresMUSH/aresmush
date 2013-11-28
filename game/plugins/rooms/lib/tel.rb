module AresMUSH
  module Rooms
    class Tel
      include AresMUSH::Plugin

      def want_command?(cmd)
        cmd.logged_in? && cmd.root_is?("tel")
      end
      
      def on_command(client, cmd)
        dest = cmd.args
        room = SingleTargetFinder.find(dest, Room, client)
        return if room.nil?
        
        client.emit_success("You teleport to #{room["name"]}.")
        client.char["location"] = room["_id"]
        Character.update(client.char)
        client.emit Describe.format_room_desc(room)
      end
    end
  end
end
