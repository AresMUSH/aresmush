module AresMUSH
  module Scenes
    class SceneLogClearCmd
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
          if (!scene.logging_enabled)
            client.emit_failure t('scenes.logging_not_enabled')
            return
          end

          if (!Scenes.can_edit_scene?(enactor, scene))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
          
          if (scene.shared)
            client.emit_failure t('scenes.scene_already_shared')
            return
          end
                  
          scene.delete_poses_and_log
          if (scene.room)
            scene.room.emit_ooc t('scenes.log_cleared_by', :name => enactor_name)
          end
          client.emit_success t('scenes.log_cleared')
        end
      end
    end
  end
end
