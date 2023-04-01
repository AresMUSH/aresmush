module AresMUSH
  module Mail
    class MailUndeleteCmd
      include CommandHandler
           
      attr_accessor :num
      
      def parse_args
        self.num = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.num ]
      end
        
      def handle
        messages_to_undelete = Mail.select_message_range(self.num)
        if (!messages_to_undelete)
          client.emit_failure t('mail.invalid_message_number')
          return
        end
        
        messages_to_undelete.each do |m|
          Mail.with_a_delivery(client, enactor, "#{m}") do |delivery|
            Mail.remove_from_trash(delivery)
            client.emit_ooc t("mail.message_undeleted", :subject => delivery.subject)
          end
        end
      end
    end
  end
end
