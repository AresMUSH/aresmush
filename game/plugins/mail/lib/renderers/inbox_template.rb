module AresMUSH
  module Mail
    class InboxTemplate
      include TemplateFormatters
      
      attr_accessor :messages
      
      def initialize(char, messages)
        @char = char
        @messages = messages
      end
      
      def folder
        "Inbox"
      end
      
    end
    
    class InboxMessageTemplate
      include TemplateFormatters
      
      def initialize(char, delivery)
        @char = char
        @delivery = delivery
        @message = delivery.message
      end
      
      def num(index)
        "#{index+1}".rjust(3)
      end
      
      def subject
        @message.subject.ljust(31)
      end
      
      def date
        @message.created_at.strftime("%m %b %Y")
      end
      
      def author
        a = @message.author.nil? ? t('mail.deleted_author') : @message.author.name
        a.ljust(22)
      end
      
      def tags
        unread = @delivery.read ? "-" : t('mail.unread_marker')
        trashed = @delivery.trashed ? t('mail.trashed_marker') : "-"
        " [#{unread}#{trashed}]  "
      end
    end
    
  end
end