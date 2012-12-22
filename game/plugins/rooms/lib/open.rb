module AresMUSH
  module Rooms
    class Open
      include AresMUSH::Plugin

      def want_command?(cmd)
        cmd.root_is?("open")
      end
      
      def on_command(client, cmd)
        regex_with_dest = /(?<name>.+)=(?<dest>.+)/
        if (cmd.can_crack_args?(regex_with_dest))
          cmd.crack_args!(regex_with_dest)
          dest = Room.find_by_name_or_id(cmd.args[:dest])
          # TODO - check for nil or more than one
          dest = dest.nil? ? nil : dest[0]
        else
          cmd.crack_args!(/(?<name>.+)/)
          dest = nil
        end
        
        exit_info = 
        { 
          "name" => cmd.args[:name], 
          "source" => cmd.location["_id"],
          "dest" => dest.nil? ? nil : dest["_id"]  # may be nil
        }
        
        e = Exit.create(exit_info)
        client.emit_success("You open an exit to #{dest.nil? ? "Nowhere" : dest["name"]}")
      end
    end
  end
end
