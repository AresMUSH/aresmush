module AresMUSH
  module Mail
    class MailDeleteCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
           
      attr_accessor :num
      
      def initialize(client, cmd, enactor)
        self.required_args = ['num']
        self.help_topic = 'mail managing'
        super
      end
      
      def crack!
        self.num = trim_input(cmd.args)
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
          delivery.tags << Mail.trashed_tag
          delivery.save
          client.emit_ooc t("mail.message_deleted", :subject => delivery.subject)
        end
      end
    end
  end
end
