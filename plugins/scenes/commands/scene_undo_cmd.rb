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
         
          if (scene.completed)
            client.emit_failure t('scenes.scene_already_completed')
            return
          end
         
          all_poses = scene.poses_in_order.select { |p| p.character == enactor && !p.is_ooc }
          last_pose = all_poses[-1]

          if (!last_pose)
            client.emit_failure t('scenes.no_pose_found')
            return
          end
        
          old_pose = last_pose.pose
          pose_id = last_pose.id
          
          last_pose.update(is_deleted: true)
          message = t('scenes.deleted_pose', :name => enactor_name,
                        :pronoun => Demographics.possessive_pronoun(enactor))

          Scenes.add_to_scene(scene, message, Game.master.system_character, false, true)
          scene.room.emit_ooc message

          data = { id: pose_id }.to_json
          Scenes.new_scene_activity(scene, :pose_deleted, data)

        end
      end
    end
  end
end
