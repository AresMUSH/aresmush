module AresMUSH
  module Mail
    class MailUndeleteCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
           
      attr_accessor :num
      
      def crack!
        self.num = trim_input(cmd.args)
      end
      
      def required_args
        {
          args: [ self.num ],
          help: 'mail managing'
        }
      end
        
      def handle
        Mail.with_a_delivery(client, enactor, self.num) do |delivery|
          delivery.tags.delete(Mail.trashed_tag)
          delivery.save
          client.emit_ooc t("mail.message_undeleted", :subject => delivery.message.subject)
        end
      end
    end
  end
end
