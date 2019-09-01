module AresMUSH
  module Scenes
    class SceneLeaveCmd
      include CommandHandler
      
      def check_approved
        return t('scenes.must_be_approved') if !enactor.is_approved?
        return nil
      end
      
      def handle
        scene_num = enactor_room.scene ? enactor_room.scene.id : nil
        
        Scenes.with_a_scene(scene_num, client) do |scene|
          
          if (scene.completed)
            client.emit_failure t('scenes.scene_already_completed')
            return
          end
          
          Scenes.leave_scene(scene, enactor)  
          Scenes.send_home_from_scene(enactor)     
          client.emit t('scenes.left_scene')
        end
      end
    end
  end
end
