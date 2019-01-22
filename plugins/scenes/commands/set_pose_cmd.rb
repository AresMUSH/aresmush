module AresMUSH
  module Scenes
    class SetPoseCmd
      include CommandHandler
      
      attr_accessor :pose
      
      def parse_args
        self.pose = cmd.args
      end
      
      def handle        
        Places.reset_place_if_moved(enactor)
        Scenes.emit_setpose(enactor, self.pose)
        
        if (cmd.switch_is?("set"))
          enactor_room.update(scene_set: pose)
        end
      end
      
      def log_command
        # Don't log poses
      end
    end
  end
end
