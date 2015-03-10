module AresMUSH
  module Mail
    class MailReviewCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
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
          sent = client.char.sent_mail
          deliveries = sent.map { |s| s.mail_deliveries }.flatten.select{ |d| d.character == model }
          
          if (self.num)
            Mail.with_a_delivery_from_a_list(client, self.num, deliveries) do |delivery|
              client.emit Mail.message_renderer.render(client, delivery)
            end
          else
            client.emit Mail.inbox_renderer.render(client, deliveries, true, t('mail.sent_review', :name => model.name))
          end
        end
      end
    end
  end
end
