module AresMUSH
  module Status
    class GoOffstageCmd
      include CommandHandler
      
      def handle        
        oocloc = Rooms.ooc_room
        
        enactor.is_afk = false
        
        # No need to save because we're going to do it when we move them
        enactor.room.emit_ooc t('status.go_ooc', :name => enactor.name)
        oocloc.emit_ooc t('status.go_ooc', :name => enactor.name)
        Rooms.move_to(client, enactor, oocloc)
      end
    end
  end
end
