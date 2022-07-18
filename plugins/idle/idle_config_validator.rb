module AresMUSH
  module Idle
    class IdleConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("idle")
      end
      
      def validate
        @validator.check_forum_exists('arrivals_category')
        @validator.require_int('days_before_idle', 7)
        @validator.require_nonblank_text('default_contact')
        @validator.check_forum_exists('idle_category')
        @validator.require_list('idle_exempt_roles')
        @validator.require_nonblank_text('idle_warn_msg')
        @validator.require_text('monthly_reminder')
        @validator.check_cron('monthly_reminder_cron')
        @validator.require_in_list("reminder_category", Jobs.categories)
        @validator.require_in_list("roster_app_category", Jobs.categories)
        @validator.require_text('roster_app_template')
        @validator.require_text('roster_arrival_msg')
        @validator.require_list('roster_fields')
        @validator.require_text('roster_welcome_msg')
        @validator.require_boolean('use_roster')
        @validator.require_boolean('restrict_roster')
        
        begin
          @validator.check_roles_exist("idle_exempt_roles")
          check_roster_fields
          
        rescue Exception => ex
          @validator.add_error "Unknown idle config error.  Fix other errors first and try again. #{ex} #{ex.backtrace[0, 3]}"
        end
        
        @validator.errors
      end
      
      def check_roster_fields
        config = Global.read_config("idle", "roster_fields")
        errors = Profile.validate_general_field_config(config)
        errors.each do |e|
          @validator.add_error "idle:roster_fields #{e}"
        end
      end
    end
  end
end