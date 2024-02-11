module AresMUSH
  module Scenes
    class SceneDeleteCmd
      include CommandHandler
      
      attr_accessor :scene_num
      
      def parse_args
        self.scene_num = integer_arg(cmd.args)
      end
      
      def required_args
        [ self.scene_num ]
      end
      
      def handle        
        Scenes.with_a_scene(self.scene_num, client) do |scene|
          if (!Scenes.can_delete_scene?(enactor, scene))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
          
          if (!scene.completed)
            client.emit_failure t('scenes.cant_delete_in_progress_scene')
            return
          end
          
          if (scene.shared)
            client.emit_failure t('scenes.cant_delete_shared_scene')
            return
          end
          
          trash_date = Scenes.move_to_trash(scene, enactor)
          client.emit_success t('scenes.scene_trashed', :id => scene.id, :date => OOCTime.local_short_timestr(enactor, trash_date))
        end
      end
    end
  end
end
