module AresMUSH
  module Mail
    class MailReplyCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
           
      attr_accessor :num
      attr_accessor :body
      
      def initialize
        self.required_args = ['body']
        self.help_topic = 'mail'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("mail") && (cmd.switch_is?("reply") || cmd.switch_is?("replyall"))
      end
      
      def crack!
        if (cmd.args =~ /=/)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2)
          self.num = trim_input(cmd.args.arg1)
          self.body = cmd.args.arg2
        else
          self.body = cmd.args
        end
      end
      
      def handle
        last_mail = client.program[:last_mail]
        if (self.num.nil?)
          if (last_mail)
            reply_to last_mail
          else
            client.emit_failure t('dispatcher.invalid_syntax', :command => 'mail')
          end
        else
          Mail.with_a_delivery(client, self.num) do |delivery|
            reply_to delivery
          end
        end
      end
      
      def reply_to(delivery)
        msg = delivery.message
        Global.logger.debug("#{self.class.name} #{client} replying to message #{self.num} (#{msg.subject}).")
        subject = t('mail.reply_subject', :subject => msg.subject)
        recipients = get_recipients(msg)
        
        if (Mail.send_mail(recipients, subject, body, client))
          client.emit_ooc t('mail.message_sent')
        end
      end
      
      def get_recipients(msg)
        recipients = [msg.author.name]
        if (cmd.switch_is?("replyall"))
          to_list = msg.to_list.split(" ")
          to_list.delete client.char.name
          recipients.concat to_list
        end
        recipients
      end
      
      def log_command
        # Don't log full command for message privacy
      end
    end
  end
end
