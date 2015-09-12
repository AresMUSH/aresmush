module AresMUSH
  module Mail
    # Template used with a forwarded message
    class ForwardedTemplate < AsyncTemplateRenderer
      include TemplateFormatters
      
      # Message template for getting the original message fields.
      attr_reader :original
      
      # The comment attached to the message.
      attr_reader :comment
      
      def initialize(client, original, comment)
        @original = MessageTemplate.new(client, original)
        @comment = comment
        super client
      end
      
      def build
        text = "#{comment}"
        text << "%r%r"
        text << "%xh---- [#{t('mail.original_message')}] ----%xn%R"
        
        text << @original.title_and_text(t('mail.from'), @original.author)
        text << @original.title_and_text(t('mail.to'), @original.to)
        text << @original.title_and_text(t('mail.sent'), @original.date)
 
        text << "%R"
        text << "#{@original.body}"
        
        text
      end
    end
  end
end