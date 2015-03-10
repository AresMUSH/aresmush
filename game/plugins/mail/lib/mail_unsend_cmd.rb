module AresMUSH
  module Mail
    class MailUnsendCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :num, :name
      
      def initialize
        self.required_args = ['name', 'num']
        self.help_topic = 'mail'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("mail") && cmd.switch_is?("unsend")
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_slash_arg2)
        self.name = trim_input(cmd.args.arg1)
        self.num = trim_input(cmd.args.arg2)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |model|
          sent = client.char.sent_mail
          deliveries = sent.map { |s| s.mail_deliveries }.flatten.select{ |d| d.character == model }
          
          Mail.with_a_delivery_from_a_list(client, self.num, deliveries) do |delivery|
            if (delivery.read)
              client.emit_failure t('mail.cant_unsend_read_mail')
            else
              client.emit_failure t('mail.mail_unsent')
              delivery.destroy
            end
          end
        end
      end
    end
  end
end
