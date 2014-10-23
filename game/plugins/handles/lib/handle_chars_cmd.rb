module AresMUSH
  module Handles
    class HandleCharsCmd
      include Plugin
      include PluginWithoutArgs
      
      def want_command?(client, cmd)
        cmd.root_is?("handle") && cmd.switch_is?("chars")
      end
      
      def handle
        Handles.list_characters(client)
      end      
    end

  end
end
