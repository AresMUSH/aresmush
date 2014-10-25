module AresMUSH
  module Handles
    class HandleIdCmd
      include Plugin
      include PluginWithoutArgs
      
      def want_command?(client, cmd)
        cmd.root_is?("handle") && cmd.switch_is?("id")
      end
      
      def handle
        if (Global.api_router.is_master?)
          client.emit_failure t('api.cant_link_on_master')
        else
          client.emit_success t('handles.character_id_is', :id => client.char.api_character_id)
        end
      end      
    end
  end
end
