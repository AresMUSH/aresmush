module AresMUSH
  module Login
    class LoginConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("login")
      end
      
      def validate
        @validator.check_cron('activity_cron')
        @validator.require_boolean('allow_game_registration')
        @validator.require_boolean('allow_web_registration')
        @validator.require_boolean('allow_game_tour')
        @validator.require_boolean('allow_web_tour')
        @validator.check_cron('blacklist_cron')
        @validator.require_text('registration_not_allowed_message')
        @validator.require_text('tour_not_allowed_message')
        @validator.require_text('login_not_allowed_message')
        @validator.check_cron('notice_cleanup_cron')
        @validator.require_int('notice_timeout_days', 1)
        @validator.require_boolean('portal_requires_registration')
        @validator.require_boolean('disable_nonadmin_logins')

        begin
          
          guests = Global.read_config("names", "guest") || []
          guests.each do |name|
            if (Character.check_name(name))
              @validator.add_error "Temp name #{name} is not a valid character name"
            end
          end
          
          if (guests.count < 25)
            @validator.add_error "You should have at least 25 guest character names to avoid collisions."
          end
          
        rescue Exception => ex
          @validator.add_error "Unknown login config error.  Fix other errors first and try again. #{ex} #{ex.backtrace[0, 3]}"
        end
        
        @validator.errors
      end
    end
  end
end