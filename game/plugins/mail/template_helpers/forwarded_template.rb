module AresMUSH
  module Mail
    # Template used with a forwarded message
    class ForwardedTemplate
      include TemplateFormatters
      
      # Message template for getting the original message fields.
      attr_reader :original
      
      # The comment attached to the message.
      attr_reader :comment
      
      def initialize(char, original, comment)
        @char = char
        @original = MessageTemplate.new(char.client, original)
        @comment = comment
      end
    end
  end
end