module AresMUSH
  module Mail
    class MailBackupCmd
      include CommandHandler
      include CommandRequiresLogin
      
      def check_too_much_mail
        return t('mail.too_much_for_backup') if enactor.mail.count > 30
        return nil
      end
      
      def handle
        client.emit_ooc t('mail.starting_backup')
        enactor.mail.each_with_index do |delivery, i|
          Global.dispatcher.queue_timer(i, "Mail Backup #{enactor.name}", client) do
            Global.logger.debug "Logging mail #{delivery.id} from #{enactor.name}."
            template = MessageTemplate.new(enactor, delivery)
            client.emit template.render
          end
        end
      end
    end
  end
end
