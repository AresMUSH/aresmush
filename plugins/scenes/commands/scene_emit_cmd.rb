module AresMUSH
  module Scenes
    class SceneEmitCmd
      include CommandHandler
      
      attr_accessor :pose, :scene_num
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)          
        self.scene_num = integer_arg(args.arg1)
        self.pose = trim_arg(args.arg2)
      end
      
      def log_command
        # Don't log poses
      end
      
      def handle
        Scenes.with_a_scene(self.scene_num, client) do |scene|
          if (!Scenes.can_read_scene?(enactor, scene))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
          
          if (scene.completed)
            client.emit_failure t('scenes.scene_already_completed')
            return
          end
          
          Scenes.emit_pose(enactor, self.pose, true, false, nil, false, scene.room)  
          if (scene.room != enactor.room)      
            client.emit_success t('scenes.pose_added.' )          
          end
        end
      end
    end
  end
end
