module AresMUSH
  module Mail
    class MailReviewCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name, :num
      
      def initialize
        self.required_args = ['name']
        self.help_topic = 'mail'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("mail") && cmd.switch_is?("review")
      end
      
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
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |model|
          deliveries = model.sent_mail_to(client.char)
          
          if (self.num)
            Mail.with_a_delivery_from_a_list(client, self.num, deliveries) do |delivery|
              template = MessageTemplate.new(client, delivery)
              template.render
            end
          else
            template = InboxTemplate.new(client, deliveries, true, t('mail.sent_review', :name => model.name))
            template.render
          end
        end
      end
    end
  end
end
