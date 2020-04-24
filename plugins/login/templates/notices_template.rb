module AresMUSH
  module Login
    class NoticesTemplate < ErbTemplateRenderer

      attr_accessor :char, :paginator
            
      def initialize(char, paginator)
        @char = char
        @paginator = paginator
        super File.dirname(__FILE__) + "/notices.erb"
      end
            
      def notice_unread(notice)
        notice.is_unread? ? "%xh(U)%xn" : "   "
      end
      
      def notice_hint(notice)
        case notice.type
        when 'pm'
          "pm/review"
        when 'mail'
          "mail/new"
        when 'forum'
          "forum/new"
        when 'event'
          "events"
        when 'scene'
          "website"
        when 'job'
          Jobs.can_access_jobs?(@char) ? "jobs/new" : "requests"
        else
          ""
        end
      end
      
      def notice_timestamp(notice)
        OOCTime.local_long_timestr(@char, notice.timestamp)
      end
      
      def motd
        Game.master.login_motd
      end
    end
  end
end