module AresMUSH
  module OOCTime
    class TimeTemplate < ErbTemplateRenderer

      include TemplateFormatters
      
      def initialize(enactor)
        @enactor = enactor
        super File.dirname(__FILE__) + "/time.erb"
      end
            
      def server_time
        DateTime.now.strftime("%a %b %d, %Y %l:%M%P")
      end
      
      def local_time
        OOCTime.local_long_timestr(@enactor, Time.now)
      end
      
      def ic_time
        ICTime::Api.ic_long_timestr ICTime::Api.ictime
      end
      
      def timezone
        t('time.timezone', :timezone => @enactor.timezone)
      end
      
    end
  end
end