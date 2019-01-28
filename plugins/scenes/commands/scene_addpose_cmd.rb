module AresMUSH
  module Scenes
    class SceneAddPoseCmd
      include CommandHandler
      
      attr_accessor :pose
      
      attr_accessor :all, :scene_num
      
      def parse_args
        if (cmd.args =~ /=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)          
          self.scene_num = integer_arg(args.arg1)
          self.pose = trim_arg(args.arg2)
        else
          self.scene_num = enactor_room.scene ? enactor_room.scene.id : nil
          self.pose = trim_arg(cmd.args)
        end
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
          
          Scenes.add_to_scene(scene, self.pose, enactor)
          client.emit_success t('scenes.pose_added', :pose => self.pose )          
        end
      end
    end
  end
end
