module AresMUSH
  module Mail
    class MailStartCmd
      include CommandHandler
           
      attr_accessor :names
      attr_accessor :subject
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.names = list_arg(args.arg1)
        self.subject = trim_arg(args.arg2)
      end
      
      def required_args
        [ self.names, self.subject ]
      end
      
      def handle
        if (!Mail.validate_recipients(self.names, client))
          return
        end
        
        composition = MailComposition.create(to_list: self.names, subject: self.subject)
        enactor.update(mail_composition: composition)
        
        client.emit_ooc t('mail.mail_started', :subject => self.subject)
      end
    end
  end
end
