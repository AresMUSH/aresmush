module AresMUSH
  module Mail
    class MailStartCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
           
      attr_accessor :names
      attr_accessor :subject
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.names = !cmd.args.arg1 ? [] : cmd.args.arg1.split(" ")
        self.subject = cmd.args.arg2
      end
      
      def required_args
        {
          args: [ self.names, self.subject ],
          help: 'mail composition'
        }
      end
      
      def handle
        if (!Mail.validate_recipients(self.names, client))
          return
        end
        
        composition = MailComposition.create(to_lis: self.names, subject: self.subject)
        enactor.update(mail_composition: composition)
        
        client.emit_ooc t('mail.mail_started', :subject => self.subject)
      end
    end
  end
end
