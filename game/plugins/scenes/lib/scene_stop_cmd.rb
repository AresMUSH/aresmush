module AresMUSH
  module Scenes
    class SceneStopCmd
      include CommandHandler
      
      attr_accessor :scene_num
      
      def parse_args
        self.scene_num = integer_arg(cmd.args)
      end
      
      def required_args
        {
          args: [ self.scene_num ],
          help: 'scenes'
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
        
        scene.room.characters.each do |c|
          connected_client = c.client
          if (connected_client)
            connected_client.emit t('scenes.scene_ending')
          end
          Rooms::Api.send_to_welcome_room(connected_client, c)
        end
        
        scene.room.delete
        scene.delete
        client.emit_success t('scenes.scene_stopped')
      end
    end
  end
end
