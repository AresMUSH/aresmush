module AresMUSH
  module Describe
    class DescribeConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("describe")
      end
      
      def validate
        @validator.require_boolean('always_show_idle_in_rooms')
        @validator.require_nonblank_text('exit_end_bracket')
        @validator.require_nonblank_text('exit_start_bracket')
        @validator.require_nonblank_text('glance_format')
        @validator.require_hash('tag_colors')

        begin
          Describe.format_glance_output(Game.master.system_character)
        rescue Exception => ex
          @validator.add_error "describe::glance_format contains invalid fields."
        end
        @validator.errors
      end
    end
  end
end