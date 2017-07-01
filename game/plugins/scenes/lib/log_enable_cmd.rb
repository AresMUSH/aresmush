module AresMUSH
  module Scenes
    class ReposeSetCmd
      include CommandHandler
      
      attr_accessor :option
      
      def parse_args
        self.option = OnOffOption.new(cmd.switch)
      end
      
      def check_option
        return self.option.validate
      end
      
      def handle
        room = enactor.room
        repose = room.repose_info
        
        if (room.room_type == "OOC")
          client.emit_failure t('pose.repose_not_in_ooc')
          return
        end
        
        if (self.option.is_on?)
          if (enactor.room.repose_on?)
            client.emit_ooc t('pose.repose_already_on')
          else
            Pose.enable_repose(enactor.room)
            room.emit_ooc t('pose.repose_turned_on', :name => enactor_name)
          end
        else
          if (!enactor.room.repose_on?)
            client.emit_ooc t('pose.repose_already_off')
          else
            repose.update(enabled: false)
            room.emit_ooc t('pose.repose_turned_off', :name => enactor_name)
          end
        end
      end
    end
  end
end
