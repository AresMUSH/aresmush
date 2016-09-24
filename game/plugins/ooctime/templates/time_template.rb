module AresMUSH
  module OOCTime
    class TimeTemplate < ErbTemplateRenderer

      include TemplateFormatters

      attr_accessor :client
      
      def initialize(client)
        @client = client
        super File.dirname(__FILE__) + "/time.erb"
      end
            
      def server_time
        DateTime.now.strftime("%a %b %d, %Y %l:%M%P")
      end
      
      def local_time
        OOCTime.local_long_timestr(@client, Time.now)
      end
      
      def timezone
        t('time.timezone', :timezone => @client.char.timezone)
      end
      
    end
  end
end