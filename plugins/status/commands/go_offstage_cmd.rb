module AresMUSH
  module Status
    class GoOffstageCmd
      include CommandHandler
      
      def handle        
        oocloc = Rooms.ooc_room
        
        enactor.is_afk = false
        
        # No need to save because we're going to do it when we move them
        Rooms.emit_ooc_to_room(enactor.room, t('status.go_ooc', :name => enactor.name))
        Rooms.emit_ooc_to_room(oocloc, t('status.go_ooc', :name => enactor.name))
        Rooms.move_to(client, enactor, oocloc)
      end
    end
  end
end
