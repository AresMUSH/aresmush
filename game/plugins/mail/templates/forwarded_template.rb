module AresMUSH
  module Mail
    class ForwardedTemplate < ErbTemplateRenderer
      include TemplateFormatters
      
      attr_accessor :original, :comment
            
      def initialize(client, original, comment)
        @original = MessageTemplate.new(client, original)
        @comment = comment
        super File.dirname(__FILE__) + "/forwarded.erb"
      end
    end
  end
end