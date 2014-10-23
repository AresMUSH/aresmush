module AresMUSH
  module Handles
    class HandleIdCmd
      include Plugin
      include PluginWithoutArgs
      
      def want_command?(client, cmd)
        cmd.root_is?("handle") && cmd.switch_is?("id")
      end
      
      def handle
        Handles.get_character_id(client)
      end      
    end

  end
end
