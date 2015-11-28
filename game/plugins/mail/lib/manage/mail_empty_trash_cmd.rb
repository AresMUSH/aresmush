module AresMUSH
  module Mail
    class MailEmptyTrashCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      
      def want_command?(client, cmd)
        cmd.root_is?("mail") && cmd.switch_is?("emptytrash")
      end
      
      def handle
        Mail.empty_trash(client)
        client.emit_ooc t('mail.trash_emptied')
      end
    end
  end
end
