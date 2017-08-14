module AresMUSH
  module Mail
    class MailReviewCmd
      include CommandHandler
      
      attr_accessor :name, :num
      
      def parse_args
        if (cmd.args && cmd.args.include?("/"))
          args = cmd.parse_args(ArgParser.arg1_slash_arg2)
          self.name = trim_arg(args.arg1)
          self.num = trim_arg(args.arg2)
        else
          self.name = trim_arg(cmd.args)
          self.num = nil
        end
      end

      def required_args
        [ self.name ]
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          enactor.update(mail_filter: "review #{model.name}")
          template = InboxTemplate.new(enactor, Mail.filtered_mail(enactor, enactor.mail_filter), false, enactor.mail_filter)
          client.emit template.render
        end
      end
    end
  end
end
