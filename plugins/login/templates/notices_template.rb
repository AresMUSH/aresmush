module AresMUSH
  module Login
    class NoticesTemplate < ErbTemplateRenderer

      attr_accessor :char
            
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/notices.erb"
      end
      
      def notices
        messages = []
        if (has_unread_mail?)
          messages << t('login.unread_mail')
        end
        if (has_unread_pages?)
          messages << t('login.unread_pages')
        end
        if (has_unread_requests?)
          messages << t('login.unread_requests')
        end
        if (has_unread_forum?)
          messages << t('login.unread_forum')
        end
        if (has_unread_jobs?)
          messages << t('login.unread_jobs')
        end
        
        if (messages.empty?)
          messages << t('login.all_caught_up')
        end
        
        messages
      end
        
      
      def has_unread_mail?
        @char.has_unread_mail?
      end
      
      def alts
        AresCentral.alts(@char).select { |a| a != @char }
      end
      
      def has_alt_mail?(alt)
        alt.has_unread_mail?
      end
      
      def has_alt_pages?(alt)
        Page.has_unread_page_threads?(@char)
      end
      
      def has_unread_forum?
        Forum.has_unread_forum_posts?(@char)
      end
      
      def has_unread_jobs?
        @char.has_unread_jobs?
      end
      
      def has_unread_requests?
        @char.has_unread_requests?
      end
      
      def has_unread_pages?
        Page.has_unread_page_threads?(@char)
      end
      
      def approval_notice
        Chargen.approval_job_notice(@char)
      end
      
      def start_datetime_local(event)
        event.start_datetime_local(@char)
      end
      
      def start_time_standard(event)
        event.start_time_standard
      end
      
      def motd
        text = Game.master.login_motd
        if (text && text.length < 78)
          text = center(text, 78)
        end
        text
      end
    end
  end
end