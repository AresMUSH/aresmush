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
        Scenes.with_a_scene(self.scene_num, client) do |scene|
          if (!Scenes.can_manage_scene(enactor, scene))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
        
          Scenes.stop_scene(scene)
          if (scene.is_private?)
            client.emit_success t('scenes.scene_stopped')
          else
            client.emit_success t('scenes.scene_stopped_and_shared')
          end
        end
      end
    end
  end
end
