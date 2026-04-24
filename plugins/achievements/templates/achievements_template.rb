module AresMUSH
  module Achievements
    class AchievementsTemplate < ErbTemplateRenderer
             
      attr_accessor :list, :char, :viewer 
                     
      def initialize(list, char, viewer)
        @list = list
        @char = char
        @viewer = viewer
        super File.dirname(__FILE__) + "/achievements.erb"        
      end
      
      def staff_hint(name)
        return nil if !Achievements.can_manage_achievements?(self.viewer)
        "%xh%xx(#{name})%xn"
      end
      
      def show_scene_stats
        self.viewer == self.char
      end
      
      def words_per_scene
        words = @char.pose_word_count
        scenes = @char.scenes_participated_in.count
        if (words > 0 && scenes > 0)
          words_per_scene = ((words + 0.0) / scenes).round
        else
          words_per_scene = 0
        end
        words_per_scene
      end
      
      def format_message(data)
        Achievements.achievement_message(data)
      end
    end
  end
end

