module AresMUSH
  module Describe
    class Look
      include AresMUSH::Plugin

      def want_command?(cmd)
        cmd.root_is?("look") || cmd.root_is?("l")
      end
      
      def on_command(client, cmd)
        if (cmd.args.nil?)
          room = cmd.location
          desc = Describe.room_desc(room)
          client.emit_with_lines desc
        else 
          
        end
      end
    end
  end
end
