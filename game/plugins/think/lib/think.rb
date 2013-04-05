module AresMUSH
  module Think
    class Think
      include AresMUSH::Plugin

      def want_command?(cmd)
        cmd.root_is?("think")
      end
      
      def on_command(client, cmd)
        client.emit Formatter.perform_subs(cmd.args)
      end
    end
  end
end
