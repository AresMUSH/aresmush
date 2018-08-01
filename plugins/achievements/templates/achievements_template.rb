module AresMUSH
  module Achievements
    class AchievementsTemplate < ErbTemplateRenderer
             
      attr_accessor :list, :name
                     
      def initialize(list, name)
        @list = list
        @name = name
        super File.dirname(__FILE__) + "/achievements.erb"        
      end
    end
  end
end

