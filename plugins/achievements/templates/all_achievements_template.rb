module AresMUSH
  module Achievements
    class AllAchievementsTemplate < ErbTemplateRenderer
             
      attr_accessor :viewer
      
      def initialize(viewer)
        @viewer = viewer
        super File.dirname(__FILE__) + "/all_achievements.erb"        
      end
      
      def achievements
        Achievements.all_achievements.sort_by { |k, v| [v['type'], v['message']] }
      end
      
      def message(data)
        (data['message'] || "---") % { count: 'XXX' }
      end
      
      def achievement_type(data)
        (data['type'] || "---").titlecase
      end
      
      def achievement_key(name)
        Achievements.can_manage_achievements?(self.viewer) ? "%xh%xx(#{name})%xn" : ""
      end
      
      def levels(name, data)
        all_levels = Achievements.achievement_levels(name)
        return all_levels ? "%R%T#{all_levels.join(", ")}" : ""
      end
      
    end
  end
end

