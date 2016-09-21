module AresMUSH
  module Mail
    class MailUnsendCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :num, :name
      
      def initialize
        self.required_args = ['name', 'num']
        self.help_topic = 'mail'
        super
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_slash_arg2)
        self.name = trim_input(cmd.args.arg1)
        self.num = trim_input(cmd.args.arg2)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |model|
          deliveries = model.sent_mail_to(client.char)
          
          Mail.with_a_delivery_from_a_list(client, self.num, deliveries) do |delivery|
            if (delivery.read)
              client.emit_failure t('mail.cant_unsend_read_mail')
            else
              client.emit_failure t('mail.mail_unsent')
              delivery.destroy
            end
          end
        end
      end
    end
  end
end
