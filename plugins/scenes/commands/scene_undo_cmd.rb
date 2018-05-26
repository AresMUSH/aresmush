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
          message = t('scenes.deleted_pose', :name => enactor_name,
                        :pronoun => Demographics.possessive_pronoun(enactor))
          
          cene.room.emit "%xr*** #{message} ***%xn"
        end
      end
    end
  end
end
