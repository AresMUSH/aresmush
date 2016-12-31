module AresMUSH
  module Describe
    class SceneSetCmd
      include CommandHandler
      
      attr_accessor :set
      
      def crack!
        self.set = cmd.args ? trim_input(cmd.args) : nil
      end
      
      def handle
        room = enactor.room
        scene_set = room.scene_set
        
        if (self.set)
          if (scene_set)
            scene_set.update(set: self.set)
            scene_set.update(time: Time.now)
          else
            scene_set = SceneSet.create(room: room, set: self.set, time: Time.now)
            room.update(scene_set: scene_set)
          end
          client.emit_success t('describe.scene_set')
        else
          if (scene_set)
            scene_set.delete
          end
          client.emit_success t('describe.scene_set_cleared')
        end
      end
    end
  end
end
