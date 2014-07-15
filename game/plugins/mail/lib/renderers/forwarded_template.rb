module AresMUSH
  module Mail
    class ForwardedTemplate
      include TemplateFormatters
      
      attr_reader :original, :comment
      
      def initialize(char, original, comment)
        @char = char
        @original = MessageTemplate.new(char, original)
        @comment = comment
      end
    end
  end
end