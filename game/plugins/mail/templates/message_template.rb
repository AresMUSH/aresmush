module AresMUSH
  module Mail
    class MessageTemplate < ErbTemplateRenderer
      include TemplateFormatters
      
      attr_accessor :message
      
      def initialize(client, message)
        @client = client
        @char = client.char
        @message = message
        super File.dirname(__FILE__) + "/message.erb"
      end
      
      def date
        OOCTime::Api.local_long_timestr(@client, @message.created_at)
      end
      
      # Some of these fields are redundant, but the forward template needs them.
      def body
        @message.body
      end
      
      def to
        @message.to_list
      end
      
      def tags
        @message.tags.join(", ")
      end
      
      def author
        @message.author.nil? ? t('mail.deleted_author') : @message.author.name
      end
    end
  end
end