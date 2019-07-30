module AresMUSH
  module Scenes
    class SetPoseCmd
      include CommandHandler
      
      attr_accessor :pose
      
      def parse_args
        self.pose = cmd.args
      end
      
      def handle        
        Scenes.emit_setpose(enactor, self.pose)
        
        if (cmd.switch_is?("set"))
          enactor_room.update(scene_set: pose)
          
          scene = enactor_room.scene
          if (scene)
            data = Scenes.build_location_web_data(scene).to_json
            Scenes.new_scene_activity(scene, :location_updated, data)
          end
        end
      end
      
      def log_command
        # Don't log poses
      end
    end
  end
end
