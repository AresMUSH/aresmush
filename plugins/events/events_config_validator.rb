module AresMUSH
  module Events
    class EventsConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("events")
      end
      
      def validate
        @validator.check_cron('event_alert_cron')
        @validator.errors
      end
    end
  end
end