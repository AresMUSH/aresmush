module AresMUSH
  module Mail
    class MessageTemplate < ErbTemplateRenderer
      
      attr_accessor :message
      
      def initialize(enactor, message)
        @enactor = enactor
        @message = message
        super File.dirname(__FILE__) + "/message.erb"
      end
      
      def date
        OOCTime.local_long_timestr(@enactor, @message.created_at)
      end
      
      def tags
        @message.tags.join(", ")
      end
      
      def author
        !@message.author ? t('global.deleted_character') : @message.author.name
      end
    end
  end
end