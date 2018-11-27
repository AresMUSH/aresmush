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
        Mail.with_a_delivery(client, enactor, self.num) do |delivery|
          Mail.archive_delivery(delivery)
          client.emit_success t('mail.message_archived')
        end
      end
    end
  end
end
