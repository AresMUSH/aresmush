module AresMUSH
  module Achievements
    class AchievementsTemplate < ErbTemplateRenderer
             
      attr_accessor :list, :char, :viewer 
                     
      def initialize(list, name, viewer)
        @list = list
        @char = name
        @viewer = viewer
        super File.dirname(__FILE__) + "/achievements.erb"        
      end
      
      def staff_hint(name)
        return nil if !Achievements.can_manage_achievements?(self.viewer)
        "%xh%xx(#{name})%xn"
      end
    end
  end
end

