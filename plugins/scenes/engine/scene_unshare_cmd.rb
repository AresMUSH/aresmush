module AresMUSH
  module Scenes
    class SceneUnshareCmd
      include CommandHandler
      
      attr_accessor :scene_num
      
      def parse_args
        if (cmd.args)
          self.scene_num = integer_arg(cmd.args)
        else
          self.scene_num = enactor_room.scene ? enactor_room.scene.id : nil
        end
      end
      
      def handle
        
        Scenes.with_a_scene(self.scene_num, client) do |scene|          
          
          if (!Scenes.can_access_scene?(enactor, scene))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
          
          if (!scene.shared)
            client.emit_failure t('scenes.scene_not_shared')
            return
          end
          
          scene.update(shared: false)
          if (scene.scene_log)
            Scenes.add_to_scene(scene, scene.scene_log.log, scene.owner)
            scene.scene_log.delete
          end
          client.emit_success t('scenes.log_unshared', :name => enactor_name)
        end
      end
    end
  end
end
