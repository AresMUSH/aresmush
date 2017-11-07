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
        
          scene.delete_poses_and_log
          Rooms.emit_ooc_to_room(scene.room, t('scenes.log_cleared'))
        end
      end
    end
  end
end
