module AresMUSH
  module Mail
    class MailBackupCmd
      include CommandHandler
      
      def handle
        client.emit_ooc t('mail.starting_backup')
        tags = Mail.all_tags(enactor)
        backup = {}

        old_title = ""
        
        tags.each do |tag|
          mail = Mail.filtered_mail(enactor, tag)

          mail.each_with_index do |delivery, i|
            backup["#{tag}-#{i}"] = delivery
          end
        end
                   
        Global.logger.debug "Logging mail from #{enactor.name}."
 
        backup.each_with_index do |(key, delivery), i| 
          
          Global.dispatcher.queue_timer(i, "Mail Backup #{enactor.name}", client) do
            title = delivery.tags.join(", ")
            template = MessageTemplate.new(enactor, delivery)
            if (title != old_title)
              old_title = title
              client.emit "%R#{title}%R---------------"
            end
            client.emit template.render
          end
        end
        Global.dispatcher.queue_timer(backup.count + 2, "Mail archive", client) do
          client.emit_success t('global.done')
        end
      end
    end
  end
end
