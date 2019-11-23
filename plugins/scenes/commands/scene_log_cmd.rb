module AresMUSH
  module Scenes
    class SceneLogCmd
      include CommandHandler
      
      attr_accessor :all, :scene_num, :num_poses
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_slash_arg2)
        self.scene_num = integer_arg(args.arg1)
        
        if (self.scene_num)
          self.num_poses = integer_arg(args.arg2)
        else
          self.scene_num = enactor_room.scene ? enactor_room.scene.id : nil
          self.num_poses = integer_arg(cmd.args)
        end
        self.all = cmd.switch_is?("log")
      end
      
      def handle    
        Scenes.with_a_scene(self.scene_num, client) do |scene|
          if (!scene.logging_enabled)
            client.emit_failure t('scenes.logging_not_enabled')
            return
          end
          
          can_access = Scenes.can_read_scene?(enactor, scene) || 
            ((enactor.room == scene.room ) && !scene.completed)
          if (!can_access)
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
          
          if (!self.num_poses || self.num_poses == 0)
            # 3 x participants, min 10 max 20
            self.num_poses = [ [scene.participants.count * 3, 20].min, 10 ].max
          end
          scene.mark_read(enactor)
          
          template = SceneLogTemplate.new scene, self.all, self.num_poses
          client.emit template.render
        end
      end
    end
  end
end
