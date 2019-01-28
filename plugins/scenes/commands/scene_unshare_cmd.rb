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
          
          if (!Scenes.can_edit_scene?(enactor, scene))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
          
          if (!scene.shared)
            client.emit_failure t('scenes.scene_not_shared')
            return
          end
          
          Scenes.unshare_scene(enactor, scene)
          
          client.emit_success t('scenes.log_unshared', :name => enactor_name)
        end
      end
    end
  end
end
