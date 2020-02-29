module AresMUSH
  module Achievements
    class AchievementConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("achievements")
      end
      
      def validate
        @validator.require_hash("achievements")
        @validator.errors
      end
    end
  end
end