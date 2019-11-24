module AresMUSH
  module Scenes
    class SceneReposeCmd
      include CommandHandler
      
      attr_accessor  :scene_num, :num_poses
      
      def parse_args
        self.scene_num = enactor_room.scene ? enactor_room.scene.id : nil
        self.num_poses = integer_arg(cmd.args)
      end

      def required_args
        [ self.scene_num ]
      end
            
      def handle    
        Scenes.with_a_scene(self.scene_num, client) do |scene|
          if (!scene.logging_enabled)
            client.emit_failure t('scenes.logging_not_enabled')
            return
          end
          
          can_access = Scenes.can_read_scene?(enactor, scene) || 
            ((enactor.room == scene.room ) && !scene.completed)
          if (!can_access)
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
          
          if (!self.num_poses || self.num_poses == 0)
            # 3 x participants, min 10 max 20
            self.num_poses = [ [scene.participants.count * 3, 20].min, 10 ].max
          end
          scene.mark_read(enactor)
          
          template = SceneLogTemplate.new scene, false, self.num_poses
          client.emit template.render
        end
      end
    end
  end
end
