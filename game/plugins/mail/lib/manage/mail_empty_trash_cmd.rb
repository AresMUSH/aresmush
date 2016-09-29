module AresMUSH
  module Mail
    class MailEmptyTrashCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      
      def handle
        Mail.empty_trash(enactor)
        client.emit_ooc t('mail.trash_emptied')
      end
    end
  end
end
