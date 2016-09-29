module AresMUSH
  module Mail
    class MailUndeleteCmd
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
        Mail.with_a_delivery(client, self.num) do |delivery|
          delivery.tags.delete(Mail.trashed_tag)
          delivery.save
          client.emit_ooc t("mail.message_undeleted", :subject => delivery.message.subject)
        end
      end
    end
  end
end
