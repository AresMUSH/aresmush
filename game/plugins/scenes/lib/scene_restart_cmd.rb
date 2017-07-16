module AresMUSH
  module Scenes
    class SceneRestartCmd
      include CommandHandler
      
      attr_accessor :scene_num
      
      def parse_args
        self.scene_num = integer_arg(cmd.args)
      end
      
      def required_args
        {
          args: [ self.scene_num ],
          help: 'scenes creating'
        }
      end
      
      def handle
        Scenes.with_a_scene(self.scene_num, client) do |scene|
          if (!Scenes.can_access_scene?(enactor, scene))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
          
          if (!scene.completed)
            client.emit_failure t('scenes.cant_restart_in_progress_scene')
            return
          end
          
          if (scene.shared)
            client.emit_failure t('scenes.cant_restart_shared_scene')
            return
          end
          
          room = Room.create(scene: scene, room_type: "RPR", name: "Scene #{scene.id} - #{scene.location}")
          ex = Exit.create(name: "O", source: room, dest: Game.master.ooc_room)
          scene.update(room: room)
          scene.update(temp_room: true)
          scene.update(completed: false)
          Rooms.move_to(client, enactor, room)
          client.emit_success t('scenes.scene_restarted')
        end        
      end
    end
  end
end
