module AresMUSH
  module Mail
    class MailFilterCmd
      include CommandHandler
      include CommandRequiresLogin

      attr_accessor :tag
            
      def crack!
        self.tag = titleize_input(cmd.args)        
      end
      
      def handle
        prefs = Mail.get_or_create_mail_prefs(enactor)
        show_from = true
        
        if (cmd.switch_is?("inbox"))
          prefs.update(mail_filter:  Mail.inbox_tag)
        elsif (cmd.switch_is?("archive"))
          prefs.update(mail_filter: Mail.archive_tag)
        elsif (cmd.switch_is?("sent"))
          prefs.update(mail_filter: Mail.sent_tag)
          show_from = false
        elsif (cmd.switch_is?("trash"))
          prefs.update(mail_filter: Mail.trashed_tag)
        else
          prefs.update(mail_filter: self.tag || Mail.inbox_tag)
        end
        
        client.emit "#{show_from} #{prefs.mail_filter}"
        template = InboxTemplate.new(enactor, Mail.filtered_mail(enactor), show_from, prefs.mail_filter)
        client.emit template.render
      end
    end
  end
end
