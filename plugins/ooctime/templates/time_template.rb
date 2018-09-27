module AresMUSH
  module OOCTime
    class TimeTemplate < ErbTemplateRenderer

      
      def initialize(enactor)
        @enactor = enactor
        super File.dirname(__FILE__) + "/time.erb"
      end
            
      def server_time
        l(DateTime.now, format: Global.read_config("datetime", "long_date_format"))
      end
      
      def local_time
        OOCTime.local_long_timestr(@enactor, Time.now)
      end
      
      def ic_time
        ICTime.ic_long_timestr ICTime.ictime
      end
      
      def timezone
        t('time.timezone', :timezone => @enactor.timezone)
      end
      
      def ratio
        ICTime.ratio_str
      end
      
      def server_timezone
        Global.read_config("datetime", "server_timezone")
      end
      
    end
  end
end