module AresMUSH
  module Describe
    class SceneSetCmd
      include CommandHandler
      include CommandRequiresLogin
      
      attr_accessor :set
      
      def crack!
        self.set = cmd.args ? trim_input(cmd.args) : nil
      end
      
      def handle
        room = enactor.room
        
        if (self.set)
          room.sceneset = self.set
          room.sceneset_time = Time.now
          room.save
          client.emit_success t('describe.scene_set')
        else
          room.sceneset = nil
          room.save
          client.emit_success t('describe.scene_set_cleared')
        end
      end
    end
  end
end
