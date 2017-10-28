module AresMUSH
  module Scenes
    class SceneLogCmd
      include CommandHandler
      
      attr_accessor :all, :scene_num
      
      def parse_args
        if (cmd.args)
          self.scene_num = integer_arg(cmd.args)
        else
          self.scene_num = enactor_room.scene ? enactor_room.scene.id : nil
        end
        self.all = cmd.switch_is?("log")
      end
      
      def handle    
        Scenes.with_a_scene(self.scene_num, client) do |scene|
          if (!scene.logging_enabled)
            client.emit_failure t('scenes.logging_not_enabled')
            return
          end
          
          can_access = Scenes.can_access_scene?(enactor, scene) || 
            ((enactor.room == scene.room ) && !scene.completed)
          if (!can_access)
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
          
          template = SceneLogTemplate.new scene, !self.all
          client.emit template.render
        end
      end
    end
  end
end
