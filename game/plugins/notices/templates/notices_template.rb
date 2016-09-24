module AresMUSH
  module Notices
    class NoticesTemplate < ErbTemplateRenderer
      include TemplateFormatters

      attr_accessor :char
            
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/notices.erb"
      end
      
      def mail
        Mail::Api.has_unread_mail?(@char) ? t('notices.unread_mail') : t('notices.no_unread_mail')
      end
      
      def alts
        return [] if !@char.handle
        Character.find_by_handle(@char.handle).select { |a| a != @char }
      end
      
      def has_alt_mail(alt)
        Mail::Api.has_unread_mail?(alt)
      end
      
      def bbs
        Bbs::Api.has_unread_bbs?(@char) ? t('notices.unread_bbs') : t('notices.no_unread_bbs')
      end
      
      def jobs_or_requests
        return t('notices.unread_requests') if Jobs::Api.has_unread_requests?(@char)
        return t('notices.unread_jobs') if Jobs::Api.has_unread_jobs?(@char)
        return t('notices.no_unread_requests')
      end
    end
  end
end