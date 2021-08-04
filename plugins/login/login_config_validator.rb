module AresMUSH
  module Login
    class LoginConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("login")
      end
      
      def validate
        @validator.check_cron('activity_cron')
        @validator.require_boolean('allow_creation')
        @validator.require_boolean('allow_web_registration')
        @validator.check_cron('blacklist_cron')
        @validator.require_text('creation_not_allowed_message')
        @validator.require_text('guest_disabled_message')
        @validator.check_role_exists('guest_role')
        @validator.require_text('login_not_allowed_message')
        @validator.check_cron('notice_cleanup_cron')
        @validator.require_int('notice_timeout_days', 1)
        @validator.require_boolean('portal_requires_registration')
        
        begin
         
         
        rescue Exception => ex
          @validator.add_error "Unknown login config error.  Fix other errors first and try again. #{ex} #{ex.backtrace[0, 3]}"
        end
        
        @validator.errors
      end
    end
  end
end