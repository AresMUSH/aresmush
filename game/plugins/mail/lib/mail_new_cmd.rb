module AresMUSH
  module Mail
    class MailNewCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      
      def handle
        unread = client.char.unread_mail.first
        if (unread.nil?)
          client.emit_ooc t('mail.no_unread_messages')
        else
          template = MessageTemplate.new(client, unread)
          client.emit template.render
          unread.read = true
          unread.save
          client.program[:last_mail] = unread
        end
      end
    end
  end
end
