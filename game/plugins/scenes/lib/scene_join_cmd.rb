module AresMUSH
  module Scenes
    class SceneJoinCmd
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
        
        can_join = Scenes.can_manage_scene(enactor, scene) || !scene.private_scene        
        if (!can_join)
          client.emit_failure t('scenes.scene_is_private')
          return
        end
        
        scene.room.emit_ooc t('scenes.scene_pending_join', :name => enactor_name)
        
        Global.dispatcher.queue_timer(3, "Join scene", client) do
          Rooms.move_to(client, enactor, scene.room)
        end
      end
    end
  end
end
