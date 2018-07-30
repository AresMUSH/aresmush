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
          poses = poses[-10, 10] || poses
        else
          poses = poses.select { |p| !p.is_ooc }
        end
        poses
      end
      
      def players
        @scene.participant_names.join(", ")
      end
      
      def log_footer
        @short_log ? t('scenes.log_list_short_footer') : nil
      end
      
      def format_pose(pose)
        if (pose.is_system_pose?)
          "   #{pose.pose}"
        elsif (pose.is_ooc)
          "<OOC> #{pose.pose}"
        else
          pose.pose
        end
      end
    
      def log_text
        text = ""
        if poses.any?
          poses.each do |p|
            text << "#{format_pose(p)}%R%R"
          end
        elsif @scene.scene_log
          text = @scene.scene_log.log
        else
          text = "----"
        end
        text
      end
    end
  end
  
end