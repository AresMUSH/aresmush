module AresMUSH
  module Mail
    class MailReviewCmd
      include Plugin
      include PluginRequiresLogin
      
      attr_accessor :name
      
      def want_command?(client, cmd)
        cmd.root_is?("mail") && cmd.switch_is?("review") && cmd.args.nil?
      end
      
      def handle
        deliveries = client.char.sent_mail.map { |s| s.mail_deliveries }.flatten
        client.emit Mail.inbox_renderer.render(client, deliveries, true, t('mail.sent_review'))
      end
    end
  end
end
