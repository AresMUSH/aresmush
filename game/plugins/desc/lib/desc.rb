module AresMUSH
  module Describe
    class Desc
      include AresMUSH::Plugin

      def want_command?(cmd)
        cmd.root_is?("desc")
      end
      
      def on_command(client, cmd)
        args = cmd.crack_args!(/(?<target>\S+)\=(?<desc>.+)/)
        
        (client.emit("You didn't supply a description!") and return) if args.nil?
        
        target = args[:target]
        desc = args[:desc]
        
        if (target == "here")  
          room = cmd.location                  
          room["desc"] = desc
          Room.update(room)
          puts room
          client.emit_success("You set the room description.")
        end
      end
    end
  end
end
