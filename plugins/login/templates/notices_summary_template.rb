module AresMUSH
  module Login
    class NoticesSummaryTemplate < ErbTemplateRenderer

      attr_accessor :char
            
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/notices_summary.erb"
      end
      
      def unread_notices
        num_unread_notices = char.unread_notifications.count
        if (num_unread_notices > 0)
          t('login.you_have_unread_notices', :count => num_unread_notices)
        else
          t('login.all_caught_up')
        end
      end
      
      def alts
        AresCentral.alts(@char).select { |a| a != @char }
      end
      
      def has_alt_mail?(alt)
        alt.has_unread_mail?
      end
      
      def has_alt_pages?(alt)
        Page.has_unread_page_threads?(alt)
      end
      
      def has_alt_notices?(alt)
        alt.unread_notifications.count > 0
      end
      
      def approval_notice
        Chargen.approval_job_notice(@char)
      end
      
      def motd
        Game.master.login_motd
      end
      
      def reboot_text
        return nil if !@char.is_admin?
        Jobs.reboot_required_notice
      end
      
    end
  end
end