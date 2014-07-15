module AresMUSH
  module Mail
    class MailNewCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs
      
      def want_command?(client, cmd)
        cmd.root_is?("mail") && cmd.switch_is?("new")
      end
      
      def handle
        unread = client.char.unread_mail.first
        if (unread.nil?)
          client.emit_ooc t('mail.no_unread_messages')
        else
          client.emit RendererFactory.message_renderer.render(client, unread)
          unread.read = true
          unread.save
        end
      end
    end
  end
end
