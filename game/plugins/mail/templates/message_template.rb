module AresMUSH
  module Mail
    # Template for an individual mail message
    class MessageTemplate < AsyncTemplateRenderer
      include TemplateFormatters
      
      def initialize(client, delivery)
        @char = client.char
        @delivery = delivery
        @message = delivery.message
        super client
      end
      
      def build
        text = "%l1%r"
        text << "%xh%x![ #{subject} ]%xn%r"
        text << "%l2%r"
        text << title_and_text(t('mail.to'), to)
        text << title_and_text(t('mail.from'), author)
        text << title_and_text(t('mail.sent'), date)
        text << title_and_text(t('mail.tags'), tags)
        text << "%l2%r"
        text << "#{body}%r"
        text << "%l1"
        
        text
      end
      
      def title_and_text(title, text)
        "%xh#{left(title, 6)}%xn #{text}%r"
      end
      
      def subject
        @message.subject
      end

      # Delivery date
      def date
        OOCTime.local_long_timestr(self.client, @message.created_at)
      end
      
      def body
        @message.body
      end
      
      def author
        @message.author.name
      end
      
      def to
        @message.to_list
      end

      def tags
        @delivery.tags.join(", ")
      end
    end
  end
end