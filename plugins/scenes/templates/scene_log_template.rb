module AresMUSH
  module Scenes
    class SceneLogTemplate < ErbTemplateRenderer
             
      attr_accessor :scene, :short_log
                     
      def initialize(scene, short_log)
        @scene = scene
        @short_log = short_log
        super File.dirname(__FILE__) + "/scene_log.erb"        
      end
      
      def poses
        poses = @scene.poses_in_order.to_a
        
        if (@short_log)
          poses = poses[-5, 5] || poses
        end
        poses
      end
      
      def players
        @scene.participant_names.join(", ")
      end
      
      def log_footer
        @short_log ? t('scenes.log_list_short_footer') : nil
      end
    end
  end
end