module AresMUSH
  module Mail
    class MailUndeleteCmd
      include CommandHandler
           
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
          tags = delivery.tags
          tags.delete Mail.trashed_tag
          delivery.update(tags: tags)
          client.emit_ooc t("mail.message_undeleted", :subject => delivery.subject)
        end
      end
    end
  end
end
