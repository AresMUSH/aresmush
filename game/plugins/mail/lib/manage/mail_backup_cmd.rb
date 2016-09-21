module AresMUSH
  module Mail
    class MailBackupCmd
      include CommandHandler
      include CommandRequiresLogin
      
      def check_too_much_mail
        return t('mail.too_much_for_backup') if client.char.mail.count > 30
        return nil
      end
      
      def handle
        client.emit_ooc t('mail.starting_backup')
        client.char.mail.each_with_index do |delivery, i|
          Global.dispatcher.queue_timer(i, "Mail Backup #{client.char.name}", client) do
            Global.logger.debug "Logging mail #{delivery.id} from #{client.char.name}."
            template = MessageTemplate.new(client, delivery)
            template.render
          end
        end
      end
    end
  end
end
