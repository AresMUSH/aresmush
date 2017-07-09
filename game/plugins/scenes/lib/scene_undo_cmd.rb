module AresMUSH
  module Scenes
    class SceneUndoCmd
      include CommandHandler
      
      attr_accessor :scene_num
      
      def parse_args
        self.scene_num = enactor_room.scene ? enactor_room.scene.id : nil
      end
      
      def handle        
        Scenes.with_a_scene(self.scene_num, client) do |scene|
         
          all_poses = scene.scene_poses.select { |p| p.character == enactor }
          last_pose = all_poses[-1]

          if (!last_pose)
            client.emit_failure t('scenes.no_pose_found')
            return
          end
        
          old_pose = last_pose.pose
            
          last_pose.delete
          scene.room.emit_ooc t('scenes.deleted_pose', :name => enactor_name, :pose => old_pose)
        end
      end
    end
  end
end
