module AresMUSH
  module Handles
    class HandleInfoCmd
      include Plugin
      include PluginWithoutArgs
      
      def want_command?(client, cmd)
        cmd.root_is?("handle") && cmd.switch_is?("info")
      end
      
      def check_is_master
        return t('api.use_command_on_central') if !Global.api_router.is_master?
        return nil
      end
      
      def check_handle_set
        return t('api.no_handle_set') if client.char.handle.blank?
        return nil
      end
      
      def handle
        char = client.char
        text = t('handles.handle_name', :name => char.handle)
        text << "%R"
        text << t('handles.handle_privacy', :privacy => char.handle_privacy)
        if (char.handle_only)
          text << "%R%R"
          text << t('handles.handle_ooc_only')
        end
        
        client.emit BorderedDisplay.text text, t('handles.handle_info_title')
      end      
    end
  end
end
