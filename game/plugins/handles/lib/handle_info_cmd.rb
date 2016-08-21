module AresMUSH
  module Handles
    class HandleInfoCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      
      def want_command?(client, cmd)
        cmd.root_is?("handle") && cmd.switch_is?("info")
      end
            
      def check_handle_set
        return t('handles.no_handle_set') if client.char.handle.blank?
        return nil
      end
      
      def handle
        char = client.char
        text = t('handles.handle_name', :name => char.handle)
        text << "%R"
        text << t('handles.handle_privacy', :privacy => char.handle_privacy)
      
        client.emit BorderedDisplay.text text, t('handles.handle_info_title')
      end      
    end
  end
end
