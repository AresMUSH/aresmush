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
        @char.has_unread_mail? ? t('notices.unread_mail') : t('notices.no_unread_mail')
      end
      
      def alts
        return [] if !@char.handle
        Character.find_by_handle(@char.handle).select { |a| a != @char }
      end
      
      def has_alt_mail(alt)
        alt.has_unread_mail?
      end
      
      def bbs
        @char.has_unread_bbs? ? t('notices.unread_bbs') : t('notices.no_unread_bbs')
      end
      
      def jobs_or_requests
        return t('notices.unread_requests') if @char.has_unread_requests?
        return t('notices.unread_jobs') if @char.has_unread_jobs?
        return t('notices.no_unread_requests')
      end
      
      def events
        Events::Api.upcoming_events
      end
      
      def start_time_local(event)
        event.start_time_local(@enactor)
      end
      
      def start_time_standard(event)
        event.start_time_standard
      end
      
    end
  end
end