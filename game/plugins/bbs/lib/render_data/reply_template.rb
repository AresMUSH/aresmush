module AresMUSH
  module Bbs
    class ReplyTemplate
      include TemplateFormatters
      
      def initialize(reply)
        @reply = reply
      end
      
      def author
        name = @reply.author.nil? ? t('bbs.deleted_author') : @reply.author.name
      end
      
      def date
        @reply.created_at.strftime("%Y-%m-%d")
      end
      
      def message
        @reply.message
      end
    end
  end
end
