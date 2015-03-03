module AresMUSH
  module Mail
    class MailEmptyTrashCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs
      
      def want_command?(client, cmd)
        cmd.root_is?("mail") && cmd.switch_is?("emptytrash")
      end
      
      def handle
        client.char.mail.each do |m|
          # DO NOT USE DESTROY here or it will force a reload of the clients 
          # for each deleted message.
          if (m.tags.include?(Mail.trashed_tag))
            if (m.message.mail_deliveries.count <= 1)
              m.message.delete # Do not destroy - see note above
            end
            m.delete # Do not destroy - see note above
          end
        end
        # Reload clients only once.
        Global.client_monitor.reload_clients
        client.emit_ooc t('mail.trash_emptied')
      end
    end
  end
end
