module AresMUSH
  module Mail
    class MailSentMailCmd
      include CommandHandler
      
      attr_accessor :option

      def parse_args
        self.option = OnOffOption.new(cmd.args)
      end

      def required_args
        {
          args: [ self.option ],
          help: 'mail sending'
        }
      end
      
      def check_option
        return self.option.validate
      end      
      
      def handle        
        enactor.update(copy_sent_mail: self.option.is_on?)

        if (self.option.is_on?)
          client.emit_ooc t('mail.sentmail_on')
        else
          client.emit_ooc t('mail.sentmail_off')
        end
      end
    end
  end
end
