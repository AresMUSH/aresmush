module AresMUSH
  module Login
    class NoticesTemplate < ErbTemplateRenderer

      attr_accessor :char
            
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/notices.erb"
      end
      
      def mail
        @char.has_unread_mail? ? t('login.unread_mail') : t('login.no_unread_mail')
      end
      
      def alts
        AresCentral.alts(@char).select { |a| a != @char }
      end
      
      def has_alt_mail(alt)
        alt.has_unread_mail?
      end
      
      def bbs
        Bbs.has_unread_bbs?(@char) ? t('login.unread_bbs') : t('login.no_unread_bbs')
      end
      
      def jobs_or_requests
        return t('login.unread_requests') if @char.has_unread_requests?
        return t('login.unread_jobs') if @char.has_unread_jobs?
        return t('login.no_unread_requests')
      end
      
      def approval_notice
        Chargen::Api.approval_job_notice(@char)
      end
      
      def events
        Events::Api.upcoming_events
      end
      
      def start_time_local(event)
        event.start_time_local(@char)
      end
      
      def start_time_standard(event)
        event.start_time_standard
      end
      
    end
  end
end