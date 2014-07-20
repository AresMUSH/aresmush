module AresMUSH
  module Notices
    class NoticesTemplate
      include TemplateFormatters
            
      def initialize(char)
        @char = char
      end
      
      def mail
        @char.has_unread_mail? ? t('notices.unread_mail') : t('notices.no_unread_mail')
      end
      
      def bbs
        @char.has_unread_bbs? ? t('notices.unread_bbs') : t('notices.no_unread_bbs')
      end
    end
  end
end