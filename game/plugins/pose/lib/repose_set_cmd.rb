module AresMUSH
  module Pose
    class ReposeSetCmd
      include CommandHandler
      include CommandRequiresLogin
      
      attr_accessor :option
      
      def crack!
        self.option = OnOffOption.new(cmd.switch)
      end
      
      def check_option
        return self.option.validate
      end
      
      def check_repose_enabled
        return t('pose.repose_disabled') if !Pose.repose_enabled
      end
      
      def handle
        room = client.char.room        
        
        if (room.room_type == "OOC")
          client.emit_failure t('pose.repose_not_in_ooc')
          return
        end
        
        if (self.option.is_on?)
          room.repose_on = true
          room.save!
          room.emit_ooc t('pose.repose_turned_on', :name => client.name)
        else
          room.repose_on = false
          room.poses = []
          room.save!
          room.emit_ooc t('pose.repose_turned_off', :name => client.name)
        end
      end
    end
  end
end
