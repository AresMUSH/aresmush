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
        Mail.with_a_delivery(client, enactor, self.num) do |delivery|
          Mail.remove_from_trash(delivery)
          client.emit_ooc t("mail.message_undeleted", :subject => delivery.subject)
        end
      end
    end
  end
end
