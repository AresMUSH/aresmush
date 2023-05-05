module AresMUSH
  module Rooms
    class RoomsConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("rooms")
      end
      
      def validate
        @validator.require_boolean('area_display_sections')
        @validator.check_cron('room_lock_cron')
        @validator.require_list('area_directory_order')

        @validator.errors
      end

    end
  end
end