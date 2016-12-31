module AresMUSH
  module Mail
    class MailReplyCmd
      include CommandHandler
           
      attr_accessor :num
      attr_accessor :body
      
      def parse_args
        if (cmd.args =~ /=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.num = trim_arg(args.arg1)
          self.body = args.arg2
        else
          self.body = cmd.args
        end
      end

      def required_args
        {
          args: [ self.body ],
          help: 'mail'
        }
      end
      
      def handle
        last_mail = client.program[:last_mail]
        if (!self.num)
          if (last_mail)
            reply_to last_mail
          else
            client.emit_failure t('dispatcher.invalid_syntax', :command => 'mail')
          end
        else
          Mail.with_a_delivery(client, enactor, self.num) do |delivery|
            reply_to delivery
          end
        end
      end
      
      def reply_to(msg)
        Global.logger.debug("#{self.class.name} #{client} replying to message #{self.num} (#{msg.subject}).")
        subject = t('mail.reply_subject', :subject => msg.subject)
        recipients = get_recipients(msg)
        
        if (Mail.send_mail(recipients, subject, body, client, enactor))
          client.emit_ooc t('mail.message_sent')
        end
      end
      
      def get_recipients(msg)
        recipients = [msg.author.name]
        if (cmd.switch_is?("replyall"))
          to_list = msg.to_list.split(" ")
          to_list.delete enactor.name
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
