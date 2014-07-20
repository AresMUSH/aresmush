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
        cmd.root.starts_with?("-")
      end
      
      def check_composing_mail
        return t('mail.not_composing_message') if !Mail.is_composing_mail?(client)
        return nil
      end
      
      def crack!
        self.body = cmd.raw.after("-").chomp
      end
      
      def handle
        client.char.mail_compose_body =  "#{client.char.mail_compose_body}#{self.body}"
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
