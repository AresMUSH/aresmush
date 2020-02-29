module AresMUSH
  module OOCTime
    class OOCTimeConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("ooctime")
      end
      
      def validate
        if (!Timezone.names.include?(Global.read_config('ooctime', 'default_timezone')))
          @validator.add_error 'ooctime:default_timezone is not a recognized timezone.' 
        end
        @validator.errors
      end

    end
  end
end