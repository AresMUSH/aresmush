module AresMUSH
  module Rooms
    class Tel
      include AresMUSH::Plugin

      def want_command?(cmd)
        cmd.root_is?("tel")
      end
      
      def on_command(client, cmd)
        dest = cmd.args
        room = Room.find_by_name_or_id(dest)
        if (room.empty?)
          client.emit_failure("Can't find that room.")
          return
        end
        
        if (room.count > 1)
          matches = room.map { |m| "- #{m["name"]} (#{m["_id"]})" }.join("\n")
          client.emit_failure("Not sure which room you mean:\n#{matches}")
          return
        end
        
        room = room[0]
        client.emit_success("You teleport to #{room["name"]}.")
        client.player["location"] = room["_id"]
        Player.update(client.player)
        client.emit_with_lines Describe.room_desc(room)
      end
    end
  end
end
