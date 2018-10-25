module AresMUSH
  module Scenes
    class SceneShareCmd
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
          
          if (!scene.completed)
            client.emit_failure t('scenes.cant_share_until_completed')
            return
          end
          
          if (scene.shared)
            client.emit_failure t('scenes.scene_already_shared')
            return
          end
          
          success = Scenes.share_scene(scene)
          
          if (!success)
            client.emit_failure Scenes.info_missing_message(scene)
          else
            client.emit_success t('scenes.log_shared', :name => enactor_name)
          end
        end
      end
    end
  end
end
