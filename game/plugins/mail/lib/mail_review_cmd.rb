module AresMUSH
  module Mail
    class MailReviewCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name, :num
      
      def crack!
        if (cmd.args && cmd.args.include?("/"))
          cmd.crack_args!(CommonCracks.arg1_slash_arg2)
          self.name = cmd.args.arg1
          self.num = cmd.args.arg2
        else
          self.name = trim_input(cmd.args)
          self.num = nil
        end
      end

      def required_args
        {
          args: [ self.name ],
          help: 'mail'
        }
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          prefs = Mail.get_or_create_mail_prefs(enactor)
          prefs.update(mail_filter: "review #{model.name}")
          template = InboxTemplate.new(enactor, Mail.filtered_mail(enactor), false, prefs.mail_filter)
          client.emit template.render
        end
      end
    end
  end
end
