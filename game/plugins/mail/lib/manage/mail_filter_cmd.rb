module AresMUSH
  module Mail
    class MailFilterCmd
      include CommandHandler
      include CommandRequiresLogin

      attr_accessor :tag

      def want_command?(client, cmd)
        cmd.root_is?("mail") && 
          (
          cmd.switch_is?("filter") || 
          cmd.switch_is?("inbox") || 
          cmd.switch_is?("sent") || 
          cmd.switch_is?("trash") || 
          (!cmd.args && cmd.switch_is?("archive"))
          )
      end
      
      def crack!
        self.tag = titleize_input(cmd.args)        
      end
      
      def handle
        char = client.char
        
        if (cmd.switch_is?("inbox"))
          char.mail_filter = Mail.inbox_tag
        elsif (cmd.switch_is?("archive"))
          char.mail_filter = Mail.archive_tag
        elsif (cmd.switch_is?("sent"))
          char.mail_filter = Mail.sent_tag
        elsif (cmd.switch_is?("trash"))
          char.mail_filter = Mail.trashed_tag
        else
          char.mail_filter = self.tag || Mail.inbox_tag
        end
        
        char.save

        template = InboxTemplate.new(client, Mail.filtered_mail(client), false, char.mail_filter)
        template.render
      end
    end
  end
end
