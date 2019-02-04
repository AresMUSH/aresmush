module AresMUSH
  module Scenes
    class SceneLogEnableCmd
      include CommandHandler
      
      attr_accessor :scene_num, :option
      
      def parse_args
        if (cmd.args)
          self.scene_num = integer_arg(cmd.args)
        else
          self.scene_num = enactor_room.scene ? enactor_room.scene.id : nil
        end
        self.option = cmd.switch_is?("startlog")
      end
           
      def handle
        
        Scenes.with_a_scene(self.scene_num, client) do |scene|          

          if (scene.completed)
            client.emit_failure t('scenes.scene_already_completed')
            return
          end
          
          if (scene.room.room_type == "OOC")
            client.emit_failure t('scenes.no_scene_in_ooc_room')
            return
          end

          if (!Scenes.can_edit_scene?(enactor, scene))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
        
          if (self.option)
            if (scene.logging_enabled)
              client.emit_ooc t('scenes.logging_already_on')
            else
              scene.update(logging_enabled: true)
              scene.room.emit_ooc t('scenes.logging_turned_on', :name => enactor_name)
            end
          else
            scene.delete_poses_and_log
            if (!scene.logging_enabled)
              client.emit_ooc t('scenes.logging_already_off')
            else
              scene.update(logging_enabled: false)
              scene.room.emit_ooc t('scenes.logging_turned_off', :name => enactor_name)
            end
          end
        end
      end
    end
  end
end
