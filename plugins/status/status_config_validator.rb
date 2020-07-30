module AresMUSH
  module Status
    class StatusConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("status")
      end
      
      def validate
        @validator.check_cron('afk_cron')
        @validator.require_hash('colors')
        @validator.require_int('minutes_before_idle')
        @validator.require_int('minutes_before_idle_disconnect')
        @validator.errors
      end

    end
  end
end