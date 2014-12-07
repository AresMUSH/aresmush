module AresMUSH
  module Mail
    class InboxTemplate
      include TemplateFormatters
      
      attr_accessor :deliveries
      
      def initialize(client)
        @client = client
        @char = client.char
        @deliveries = @char.mail
      end
      
      def folder
        "Inbox"
      end
      
      def message_num(index)
        "#{index+1}".rjust(3)
      end
      
      def message_subject(delivery)
        delivery.message.subject.ljust(31)
      end
      
      def message_date(delivery)
        OOCTime.local_short_timestr(@client, delivery.message.created_at)
      end
      
      def message_author(delivery)
        message = delivery.message
        a = message.author.nil? ? t('mail.deleted_author') : message.author.name
        a.ljust(22)
      end
      
      def message_tags(delivery)
        unread = delivery.read ? "-" : t('mail.unread_marker')
        trashed = delivery.trashed ? t('mail.trashed_marker') : "-"
        " [#{unread}#{trashed}]  "
      end
    end
    
  end
end