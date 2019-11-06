module AresMUSH
  module Mail
    class MailUnsendCmd
      include CommandHandler
      
      attr_accessor :num, :name
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_slash_arg2)
        self.name = trim_arg(args.arg1)
        self.num = trim_arg(args.arg2)
      end

      def required_args
        [ self.name, self.num ]
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          deliveries = enactor.sent_mail_to(model)
          
          Mail.with_a_delivery(client, self.num, deliveries) do |delivery|
            if (delivery.read)
              client.emit_failure t('mail.cant_unsend_read_mail')
            else
              client.emit_success t('mail.mail_unsent')
              delivery.delete
            end
          end
        end
      end
    end
  end
end
