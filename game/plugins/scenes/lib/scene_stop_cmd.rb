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
      
      def required_args
        {
          args: [ self.scene_num ],
          help: 'scenes creating'
        }
      end
      
      def handle        
        scene = Scene[self.scene_num]
        if (!scene)
          client.emit_failure t('scenes.scene_not_found')    
          return
        end
        
        if (!Scenes.can_manage_scene(enactor, scene))
          client.emit_failure t('dispatcher.not_allowed')
          return
        end
        
        Scenes.stop_scene(scene)
        client.emit_success t('scenes.scene_stopped')
      end
    end
  end
end
