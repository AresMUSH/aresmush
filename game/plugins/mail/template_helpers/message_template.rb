module AresMUSH
  module Mail
    class MessageTemplate
      include TemplateFormatters
      
      def initialize(client, delivery)
        @client = client
        @char = client.char
        @delivery = delivery
        @message = delivery.message
      end
      
      def subject
        @message.subject
      end
      
      def date
        OOCTime.local_long_timestr(@client, @message.created_at)
      end
      
      def body
        @message.body
      end
      
      def author
        @message.author.name
      end
      
      def to
        to_list = @message.mail_deliveries.map { |d| d.character.name }
        to_list.join(", ")
      end

      def tags
        @delivery.trashed ? t('mail.trashed_tag') : ""
      end
    end
  end
end