module AresMUSH
  module Profile
    class ProfileConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("profile")
      end
      
      def validate
        @validator.require_list('backup_commands')
        @validator.errors
      end

    end
  end
end