module AresMUSH
  module Scenes
    class SceneShareCmd
      include CommandHandler
      
      attr_accessor :scene_num, :share
      
      def parse_args
        if (cmd.args)
          self.scene_num = integer_arg(cmd.args)
        else
          self.scene_num = enactor_room.scene ? enactor_room.scene.id : nil
        end
        self.share = cmd.switch_is?("share") ? true : false
      end
      
      def required_args
        [ self.share]
      end
      
      def handle
        
        Scenes.with_a_scene(self.scene_num, client) do |scene|          
          
          if (!Scenes.can_access_scene?(enactor, scene))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
          
          if (!scene.completed)
            client.emit_failure t('scenes.cant_share_until_completed')
            return
          end
          
          if (self.share && !scene.all_info_set?)
            client.emit_failure t('scenes.scene_info_missing', :title => scene.title || "??", 
               :summary => scene.summary || "??", 
               :type => scene.scene_type || "??", 
               :location => scene.location || "??")
            return
          end
          
          if (self.share)
            Scenes.share_scene(scene)            
          else
            scene.update(shared: false)
          end          
          
          message = self.share ? t('scenes.log_shared', :name => enactor_name) : 
              t('scenes.log_unshared', :name => enactor_name)

          if (scene.room)
            scene.room.emit_ooc message
          else
            client.emit_success message
          end
        end
      end
    end
  end
end
