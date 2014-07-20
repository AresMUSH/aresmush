module AresMUSH
  module Mail
    class MailAppendCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
           
      attr_accessor :body
      
      def initialize
        self.required_args = ['body']
        self.help_topic = 'mail'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root.starts_with?("-") && cmd.root != "--"
      end
      
      def check_composing_mail
        return t('mail.not_composing_message') if !Mail.is_composing_mail?(client)
        return nil
      end
      
      def crack!
        self.body = cmd.raw.after("-").chomp
      end
      
      def handle
        body_so_far = client.char.mail_compose_body
        if (body_so_far.nil?)
          client.char.mail_compose_body = self.body
        else
          client.char.mail_compose_body = "#{body_so_far}%R%R#{self.body}"
        end
        client.char.save
        
        client.emit_ooc t('mail.mail_added')
      end
      
      def log_command
        # Don't log full command for message privacy
        Global.logger.debug("#{self.class.name} #{client} added to mail message.")
      end
    end
  end
end
