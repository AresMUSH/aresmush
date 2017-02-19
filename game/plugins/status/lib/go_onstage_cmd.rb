module AresMUSH
  module Status
    class GoOnstageCmd
      include CommandHandler
      
      def check_can_set_status
        return nil if Status.can_be_on_duty?(enactor)
        return t('status.newbies_cant_go_ic') if !enactor.is_approved?
        return nil
      end
      
      def handle        
        icloc = get_icloc(enactor)
        enactor.update(is_afk: false)
        # No need to save because move will do it.
        enactor.room.emit_ooc t('status.go_ic', :name => enactor.name)
        icloc.emit_ooc t('status.go_ic', :name => enactor.name)
        Rooms::Api.move_to(client, enactor, icloc)
      end
      
      def get_icloc(char)
        icloc = enactor.last_ic_location
        if (!icloc || cmd.switch_is?("reset"))
          icloc = Rooms::Api.ic_start_room
        end
        icloc
      end
        
    end
  end
end
