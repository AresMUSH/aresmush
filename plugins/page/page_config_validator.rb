module AresMUSH
  module Page
    class PageConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("page")
      end
      
      def validate
        @validator.require_text('page_color')
        @validator.check_cron('page_deletion_cron')
        @validator.require_int('page_deletion_days', 3)
        @validator.require_text('page_end_marker')
        @validator.require_text('page_start_marker')
        @validator.errors
      end

    end
  end
end