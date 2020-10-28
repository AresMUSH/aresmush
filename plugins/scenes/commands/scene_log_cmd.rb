module AresMUSH
  module Scenes
    class SceneLogCmd
      include CommandHandler
      
      attr_accessor :scene_num, :info_only
      
      def parse_args
        self.scene_num = integer_arg(cmd.args)
        
        if (!self.scene_num)
          self.scene_num = enactor_room.scene ? enactor_room.scene.id : nil
        end
        
        self.info_only = cmd.switch.blank?
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
          
          scene.mark_read(enactor)
          
          if (self.info_only)
            template = SceneLogTemplate.new scene, false, 0
          else
            template = SceneLogTemplate.new scene, true
          end
          client.emit template.render
        end
      end
    end
  end
end
