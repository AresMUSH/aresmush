module AresMUSH
  module Mail
    class MailArchiveCmd
      include CommandHandler

      attr_accessor :num

      def parse_args
        self.num = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.num ]
      end
      
      def handle
        messages_to_archive = Mail.select_message_range(self.num)
        if (!messages_to_archive)
          client.emit_failure t('mail.invalid_message_number')
          return
        end
        
        messages_to_archive.each do |m|
          Mail.with_a_delivery(client, enactor, "#{m}") do |delivery|
            Mail.archive_delivery(delivery)
            client.emit_success t('mail.message_archived')
          end
        end
      end
    end
  end
end
