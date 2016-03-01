module AresMUSH
  module Handles
    class HandleIdCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      
      def want_command?(client, cmd)
        cmd.root_is?("handle") && cmd.switch_is?("id")
      end
      
      def check_is_slave
        return t('handles.cant_link_on_master') if Global.api_router.is_master?
        return nil
      end
      
      def handle
        client.emit_success t('handles.character_id_is', :id => client.char.api_character_id)
      end      
    end
  end
end
