module AresMUSH
  module Mail
    class MailFilterCmd
      include CommandHandler

      attr_accessor :tag
            
      def parse_args
        self.tag = titlecase_arg(cmd.args)        
      end
      
      def handle
        show_from = true
        
        if (cmd.switch_is?("inbox"))
          enactor.update(mail_filter:  Mail.inbox_tag)
        elsif (cmd.switch_is?("archive"))
          enactor.update(mail_filter: Mail.archive_tag)
        elsif (cmd.switch_is?("sent"))
          enactor.update(mail_filter: Mail.sent_tag)
          show_from = false
        elsif (cmd.switch_is?("trash"))
          enactor.update(mail_filter: Mail.trashed_tag)
        else
          enactor.update(mail_filter: self.tag || Mail.inbox_tag)
        end
        
        template = InboxTemplate.new(enactor, Mail.filtered_mail(enactor, enactor.mail_filter), show_from, enactor.mail_filter)
        client.emit template.render
      end
    end
  end
end
