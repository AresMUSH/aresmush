module AresMUSH
  module Mail
    class MailReviewMsgCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :num
      
      def initialize
        self.required_args = ['num']
        self.help_topic = 'mail'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("mail") && cmd.switch_is?("review") && !cmd.args.nil?
      end
      
      def crack!
        self.num = trim_input(cmd.args)
      end
      
      def handle
        deliveries = client.char.sent_mail.map { |s| s.mail_deliveries }.flatten
        Mail.with_a_delivery_from_a_list(client, self.num, deliveries) do |delivery|
          client.emit Mail.message_renderer.render(client, delivery)
        end
      end
    end
  end
end
