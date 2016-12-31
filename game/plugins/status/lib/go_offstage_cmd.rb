module AresMUSH
  module Status
    class GoOffstageCmd
      include CommandHandler
      
      def handle        
        oocloc = Rooms::Api.ooc_room
        
        enactor.is_afk = false
        if (enactor_room.room_type == "IC")
          enactor.update(last_ic_location: enactor.room)
        end
        # No need to save because we're going to do it when we move them
        enactor.room.emit_ooc t('status.go_ooc', :name => enactor.name)
        oocloc.emit_ooc t('status.go_ooc', :name => enactor.name)
        Rooms::Api.move_to(client, enactor, oocloc)
      end
    end
  end
end
