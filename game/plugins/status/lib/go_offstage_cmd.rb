module AresMUSH
  module Status
    class GoOffstageCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      
      def handle        
        oocloc = Rooms::Api.ooc_room
        
        enactor.is_afk = false
        if (Rooms::Api.room_type(enactor.room) == "IC")
          enactor.last_ic_location_id = enactor.room.id
          # No need to save because we're going to do it when we move them
        end
        enactor.room.emit_ooc t('status.go_ooc', :name => enactor.name)
        oocloc.emit_ooc t('status.go_ooc', :name => enactor.name)
        Rooms::Api.move_to(client, enactor, oocloc)
      end
    end
  end
end
