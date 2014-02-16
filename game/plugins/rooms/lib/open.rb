module AresMUSH
  module Rooms
    class Open
      include AresMUSH::Plugin

      def want_command?(client, cmd)
        cmd.root_is?("open")
      end
      
      def validate
        return t('dispatcher.must_be_logged_in') if !client.logged_in?
        # TODO - validate args
        return nil
      end
      
      def handle
        regex_with_dest = /(?<name>.+)=(?<dest>.+)/
        if (cmd.can_crack_args?(regex_with_dest))
          cmd.crack!(regex_with_dest)
          find_result = SingleTargetFinder.find(cmd.args[:dest], Room)
          if (!find_result.found?)
            client.emit_failure(find_result.error)
            return
          end
          dest = find_result.target
        else
          cmd.crack!(/(?<name>.+)/)
          dest = nil
        end
        
        exit_info = 
        { 
          "name" => cmd.args[:name], 
          "source" => client.room,
          "dest" => dest.nil? ? nil : dest  # may be nil
        }
        
        e = Exit.create(exit_info)
        client.emit_success("You open an exit to #{dest.nil? ? "Nowhere" : dest["name"]}")
      end
    end
  end
end
