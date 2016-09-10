module AresMUSH
  module Notices
    class NoticesTemplate < AsyncTemplateRenderer
      include TemplateFormatters
            
      def initialize(char, client)
        @char = char
        super client
      end
      
      def build
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
            next if !alt.has_unread_mail?
            mail_text << "%r#{t('notices.alt_unread_mail', :name => alt.name)}"
          end
        end
        mail_text
      end
      
      
      def bbs
        Bbs::Interface.has_unread_bbs?(@char) ? t('notices.unread_bbs') : t('notices.no_unread_bbs')
      end
      
      def jobs_or_requests
        return t('notices.unread_requests') if @char.has_unread_requests?
        return t('notices.unread_jobs') if @char.has_unread_jobs?
        return t('notices.no_unread_requests')
      end
    end
  end
end