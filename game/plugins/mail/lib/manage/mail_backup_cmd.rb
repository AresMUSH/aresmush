module AresMUSH
  module Mail
    class MailBackupCmd
      include CommandHandler
      
      def handle
        client.emit_ooc t('mail.starting_backup')
        mail = enactor.mail
        mail.each_with_index do |delivery, i|
          Global.dispatcher.queue_timer(i, "Mail Backup #{enactor.name}", client) do
            Global.logger.debug "Logging mail #{delivery.id} from #{enactor.name}."
            template = MessageTemplate.new(enactor, delivery)
            client.emit template.render
          end
        end
        Global.dispatcher.queue_timer(mail.count + 2, "Mail archive", client) do
          client.emit_success t('global.done')
        end
      end
    end
  end
end
