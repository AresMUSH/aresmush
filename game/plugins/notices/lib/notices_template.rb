module AresMUSH
  module Notices
    class NoticesTemplate
      include TemplateFormatters
            
      def initialize(char)
        @char = char
      end
      
      def mail
        mail_text = @char.has_unread_mail? ? t('notices.unread_mail') : t('notices.no_unread_mail')
        if (@char.handle)
          Character.find_by_handle(@char.handle).each do |alt|
            next if alt == @char
            mail_text << "%r#{t('notices.alt_unread_mail', :name => alt.name)}"
          end
        end
        mail_text
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