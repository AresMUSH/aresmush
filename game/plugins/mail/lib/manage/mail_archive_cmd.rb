module AresMUSH
  module Mail
    class MailArchiveCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs

      attr_accessor :num

      def initialize
        self.required_args = ['num']
        self.help_topic = 'mail managing'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("mail") && cmd.switch_is?("archive")
      end
      
      def crack!
        self.num = trim_input(cmd.args)
      end
      
      def handle
        Mail.with_a_delivery(client, self.num) do |delivery|
          delivery.tags << Mail.archive_tag
          delivery.tags.uniq!
          client.emit_success t('mail.message_archived')
          delivery.save
        end
      end
    end
  end
end
