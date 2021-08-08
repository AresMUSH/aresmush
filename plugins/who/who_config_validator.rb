module AresMUSH
  module Who
    class WhoConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("who")
      end
      
      def validate
        @validator.require_list('who_fields')
        @validator.require_in_list('where_style', ['scene', 'room', 'basic'])
        
        begin
          check_who_config

        rescue Exception => ex
          @validator.add_error "Unknown website config error.  Fix other errors first and try again. #{ex} #{ex.backtrace[0, 3]}"
          
        end
        
        @validator.errors
      end

      def check_who_config
        config = Global.read_config("who", "who_fields")
        errors = Profile.validate_general_field_config(config)
        errors.each do |e|
          @validator.add_error "who:who_fields #{e}"
        end
      end
    end
  end
end