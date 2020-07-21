module AresMUSH
  module Manage
    class ConfigCronTemplate < ErbTemplateRenderer
      
      attr_accessor :crons
      
      def initialize(crons)
        @crons = crons
        super File.dirname(__FILE__) + '/config_cron.erb'
      end
      
      def cron_day(cron)
        cron['day'] || []
      end

      def cron_dow(cron)
        cron['day_of_week'] || []
      end

      def cron_hour(cron)
        cron['hour'] || []
      end

      def cron_minute(cron)
        cron['minute'] || []
      end
      
      def display_cron(value, width)
        if (value.class == Array)
          value = value.join(',')
        end
        left(value, width, '.')
      end
    end
  end
end