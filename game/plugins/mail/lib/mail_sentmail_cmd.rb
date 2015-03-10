module AresMUSH
  module Mail
    class MailSentMailCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :option
      
      def initialize
        self.required_args = ['option']
        self.help_topic = 'mail'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("mail") && cmd.switch_is?("sentmail")
      end
      
      def crack!
        self.option = OnOffOption.new(cmd.args)
      end
      
      def check_option
        return self.option.validate
      end      
      
      def handle        
        client.char.copy_sent_mail = self.option.is_on?
        client.char.save
        if (self.option.is_on?)
          client.emit_ooc t('mail.sentmail_on')
        else
          client.emit_ooc t('mail.sentmail_off')
        end
      end
    end
  end
end
