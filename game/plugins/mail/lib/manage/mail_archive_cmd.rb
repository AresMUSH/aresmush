module AresMUSH
  module Mail
    class MailArchiveCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs

      attr_accessor :num

      def initialize(client, cmd, enactor)
        self.required_args = ['num']
        self.help_topic = 'mail managing'
        super
      end
      
      def crack!
        self.num = trim_input(cmd.args)
      end
      
      def handle
        Mail.with_a_delivery(client, self.num) do |delivery|
          delivery.tags << Mail.archive_tag
          delivery.tags.delete(Mail.inbox_tag)
          delivery.tags.uniq!
          client.emit_success t('mail.message_archived')
          delivery.save
        end
      end
    end
  end
end
