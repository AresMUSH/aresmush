module AresMUSH
  module Achievements
    class AchievementConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("achievements")
      end
      
      def validate
        @validator.require_hash("achievements")
        
        Achievements.all_achievements.keys.each do |a|
          if (a !~ /^[a-z0-9\-\_ ]+$/)
            @validator.add_error "Invalid achievement key: #{a} - lowercase letters, numbers, _ and - only."
          end
        end
        @validator.errors
      end
    end
  end
end