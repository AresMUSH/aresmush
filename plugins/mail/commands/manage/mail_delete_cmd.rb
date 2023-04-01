module AresMUSH
  module Mail
    class MailDeleteCmd
      include CommandHandler
           
      attr_accessor :num
      
      def parse_args
        self.num = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.num ]
      end
      
      def handle
        messages_to_delete = Mail.select_message_range(self.num)
        
        if (!messages_to_delete)
          client.emit_failure t('mail.invalid_message_number')
          return
        end
        
        messages_to_delete.each do |m|
          Mail.with_a_delivery(client, enactor, "#{m}") do |delivery|
            Mail.move_to_trash(delivery)
            client.emit_ooc t("mail.message_deleted", :subject => delivery.subject)
          end
        end
      end
    end
  end
end
