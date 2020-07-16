module AresMUSH
  module Scenes
    class SceneStopCmd
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
          can_stop = Scenes.can_manage_scenes?(enactor) || Scenes.can_edit_scene?(enactor, scene)
          if (scene.temp_room && !can_stop)
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
          
          if (scene.completed)
            client.emit_failure t('scenes.scene_already_completed')
            return
          end
          
        
          Scenes.stop_scene(scene, enactor)
          client.emit_success t('scenes.scene_stopped', :id => scene.id)
        end
      end
    end
  end
end
