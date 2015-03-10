module AresMUSH
  module Mail
    class MailStartCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
           
      attr_accessor :names
      attr_accessor :subject
      
      def initialize
        self.required_args = ['names', 'subject']
        self.help_topic = 'mail composition'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("mail") && cmd.switch.nil? && cmd.args =~ /[\=]/ && cmd.args !~ /[\/]/
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.names = cmd.args.arg1.nil? ? [] : cmd.args.arg1.split(" ")
        self.subject = cmd.args.arg2
      end
      
      def handle
        if (!Mail.validate_recipients(self.names, client))
          return
        end
        
        client.char.mail_compose_to = self.names
        client.char.mail_compose_subject = self.subject
        client.char.save
        
        client.emit_ooc t('mail.mail_started', :subject => self.subject)
      end
    end
  end
end
