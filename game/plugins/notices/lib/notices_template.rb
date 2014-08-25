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
      
      def jobs_or_requests
        return t('notices.unread_requests') if @char.has_unread_requests?
        return t('notices.unread_jobs') if @char.has_unread_jobs?
        return t('notices.no_unread_requests')
      end
    end
  end
end