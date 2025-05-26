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
        @validator.require_list("temp_name_prefixes")
        @validator.require_list("temp_name_suffixes")

        begin
          prefixes = Global.read_config("login", "temp_name_prefixes") || []
          suffixes = Global.read_config("login", "temp_name_suffixes") || []
          
          prefixes.each do |prefix|
            suffixes.each do |suffix|
              combo = "#{prefix}#{suffix}"
              if (Character.check_name(combo))
                @validator.add_error "Temp name combo #{combo} is not a valid character name"
              end
            end
          end
          
          if (prefixes.count * suffixes.count < 50)
            @validator.add_error "You should have at least 50 combinations of temp character name+suffix to avoid collisions."
          end
         
        rescue Exception => ex
          @validator.add_error "Unknown login config error.  Fix other errors first and try again. #{ex} #{ex.backtrace[0, 3]}"
        end
        
        @validator.errors
      end
    end
  end
end