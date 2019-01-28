module AresMUSH
  module Scenes
    class SceneJoinCmd
      include CommandHandler
      
      attr_accessor :scene_num
      
      def parse_args
        self.scene_num = integer_arg(cmd.args)
      end
      
      def required_args
        [ self.scene_num ]
      end
      
      def check_approved
        return t('scenes.must_be_approved') if !enactor.is_approved?
        return nil
      end
      
      def handle
        Scenes.with_a_scene(self.scene_num, client) do |scene|
          if (scene.completed)
            client.emit_failure t('scenes.scene_not_running')
            return
          end
          
          if (!scene.room)
            Scenes.create_scene_temproom(scene)
          end
          
          can_join = Scenes.can_read_scene?(enactor, scene) || !scene.private_scene        
          if (!can_join)
            client.emit_failure t('scenes.scene_is_private')
            return
          end
          client.emit_ooc t('scenes.scene_about_to_join')
        
          scene.room.emit_ooc t('scenes.scene_pending_join', :name => enactor_name)
        
          Global.dispatcher.queue_timer(3, "Join scene", client) do
            Global.logger.debug "#{enactor_name} joining scene #{scene.id}."
            Rooms.move_to(client, enactor, scene.room)
          end
        end
      end
    end
  end
end
