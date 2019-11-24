module AresMUSH
  module Scenes
    class SceneLogTemplate < ErbTemplateRenderer
             
      attr_accessor :scene, :full_log, :num_poses
                     
      def initialize(scene, full_log, num_poses = 0)
        @scene = scene
        @full_log = full_log
        @num_poses = num_poses
        super File.dirname(__FILE__) + "/scene_log.erb"        
      end
      
      def poses
        poses = @scene.poses_in_order.to_a
        
        if (@full_log)
          poses = poses.select { |p| !p.is_ooc }
        else
          poses = poses[-@num_poses, @num_poses] || poses
        end
        poses
      end
      
      def players
        @scene.participant_names.join(", ")
      end
      
      def log_footer
        @full_log ? nil : t('scenes.log_list_short_footer')
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