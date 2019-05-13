module AresMUSH
  module Mail
    class ForwardedTemplate < ErbTemplateRenderer
      
      attr_accessor :original, :comment
            
      def initialize(enactor, original, comment)
        @original = original
        @comment = comment
        super File.dirname(__FILE__) + "/forwarded.erb"
      end
      
      def date
        OOCTime.local_long_timestr(@enactor, @original.created_at)
      end
      
      def tags
        @original.tags.join(", ")
      end
      
      def author
        !@original.author ? t('global.deleted_character') : @original.author.name
      end
    end
  end
end