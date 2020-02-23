module AresMUSH
  module Places
    class PlacesConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("places")
      end
      
      def validate
        @validator.require_text('end_marker')
        @validator.check_cron('places_cleanup_cron')
        @validator.require_text('same_place_color')
        @validator.require_text('start_marker')
        @validator.errors
      end

    end
  end
end