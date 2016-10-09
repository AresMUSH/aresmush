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
          deliveries = model.sent_mail_to(enactor)
          
          if (self.num)
            Mail.with_a_delivery_from_a_list(client, self.num, deliveries) do |delivery|
              template = MessageTemplate.new(enactor, delivery)
              client.emit template.render
            end
          else
            template = InboxTemplate.new(enactor, deliveries, false, t('mail.sent_review', :name => model.name))
            client.emit template.render
          end
        end
      end
    end
  end
end
