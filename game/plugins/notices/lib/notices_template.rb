module AresMUSH
  module Notices
    class NoticesTemplate
      include TemplateFormatters
            
      def initialize(char)
        @char = char
      end
      
      def display
        text = "%l1%r"
        text << "%xh#{notices_title}%xn%r"
        text << "#{mail}%r"
        text << "#{bbs}%r"
        text << "#{jobs_or_requests}%r"
        text << "%l1"
        
        text
      end
      
      def notices_title
        center(t('notices.notices_title'), 78)
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