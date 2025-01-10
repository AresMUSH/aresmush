module AresMUSH
  module Mail
    class MailEmptyTrashCmd
      include CommandHandler
      
      def handle
        Mail.empty_all_trash(enactor)
        client.emit_ooc t('mail.trash_emptied')
      end
    end
  end
end
