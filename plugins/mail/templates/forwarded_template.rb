module AresMUSH
  module Mail
    class ForwardedTemplate < ErbTemplateRenderer
      
      attr_accessor :original, :comment
            
      def initialize(enactor, original, comment)
        @original = MessageTemplate.new(enactor, original)
        @comment = comment
        super File.dirname(__FILE__) + "/forwarded.erb"
      end
    end
  end
end