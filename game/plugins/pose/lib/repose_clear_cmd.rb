module AresMUSH
  module Pose
    class ReposeClearCmd
      include CommandHandler
      include CommandRequiresLogin
      
      def check_repose_enabled
        return t('pose.repose_disabled') if !Pose.repose_enabled
      end
      
      def handle
        room = client.char.room        
        
        if (self.option.is_on?)
          room.repose_on = true
          room.save!
          client.emit_success t('pose.repose_turned_on')
        else
          room.repose_on = true
          room.save!
          client.emit_success t('pose.repose_turned_off')
        end
      end
    end
  end
end
