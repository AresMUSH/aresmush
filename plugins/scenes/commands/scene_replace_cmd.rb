module AresMUSH
  module Scenes
    class SceneReplaceCmd
      include CommandHandler
      
      attr_accessor :pose, :scene_num, :silent
      
      def parse_args
        self.scene_num = enactor_room.scene ? enactor_room.scene.id : nil
        self.pose = cmd.args
        self.silent = cmd.switch_is?("typo")
      end
      
      def required_args
        [ self.pose ]
      end
      
      def log_command
        # Don't log poses
      end
      
      def handle        
        Scenes.with_a_scene(self.scene_num, client) do |scene|

          all_poses = scene.scene_poses.select { |p| p.character == enactor && !p.is_ooc }
          last_pose = all_poses[-1]

          if (!last_pose)
            client.emit_failure t('scenes.no_pose_found')
            return
          end
            
          last_pose.update(pose: self.pose)
          
          Scenes.edit_pose(scene, last_pose, self.pose, enactor, !self.silent)
        end
      end
    end
  end
end
