module AresMUSH
  module Handles
    class HandleInfoCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs
      
      def want_command?(client, cmd)
        cmd.root_is?("handle") && cmd.switch_is?("info")
      end
            
      def check_handle_set
        return t('api.no_handle_set') if client.char.handle.blank?
        return nil
      end
      
      def handle
        if (Global.api_router.is_master?)
          Handles.list_characters(client)
        else
          char = client.char
          text = t('handles.handle_name', :name => char.handle)
          text << "%R"
          text << t('handles.handle_privacy', :privacy => char.handle_privacy)
        
          client.emit BorderedDisplay.text text, t('handles.handle_info_title')
        end
      end      
    end
  end
end
