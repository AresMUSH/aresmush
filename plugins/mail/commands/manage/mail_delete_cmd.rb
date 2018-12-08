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
        if (self.num =~ /\-/)
          splits = self.num.split("-")
          if (splits.count != 2)
            client.emit_failure t('mail.invalid_message_number')
            return
          end
          start_message = splits[0].to_i
          end_message = splits[1].to_i
          
          if (start_message <= 0 || end_message <= 0 || start_message > end_message)
            client.emit_failure t('mail.invalid_message_number')
            return
          end
         messages_to_delete = (start_message..end_message).to_a.reverse
          messages_to_delete.each do |m|
            delete_message(m.to_s)
          end
        else
          delete_message(self.num)
        end
      end
      
      def delete_message(num)
        Mail.with_a_delivery(client, enactor, num) do |delivery|
          Mail.move_to_trash(delivery)
          client.emit_ooc t("mail.message_deleted", :subject => delivery.subject)
        end
      end
    end
  end
end
