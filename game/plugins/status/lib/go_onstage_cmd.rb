module AresMUSH
  module Status
    class GoOnstageCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs      
      
      def check_can_set_status
        return nil if Status.can_be_on_duty?(enactor)
        return t('status.newbies_cant_go_ic') if !enactor.is_approved
        return nil
      end
      
      def handle        
        char = enactor
        icloc = get_icloc(char)
        char.is_afk = false
        # No need to save because move will do it.
        char.room.emit_ooc t('status.go_ic', :name => char.name)
        icloc.emit_ooc t('status.go_ic', :name => char.name)
        Rooms::Api.move_to(client, enactor, icloc)
      end
      
      def get_icloc(char)
        icloc_id = char.last_ic_location_id
        ic_start_room = Rooms::Api.ic_start_room
        icloc = ic_start_room
        if (!icloc_id.nil? && !cmd.switch_is?("reset"))
          icloc = Room.find(icloc_id)
        end
        icloc || ic_start_room
      end
        
    end
  end
end
