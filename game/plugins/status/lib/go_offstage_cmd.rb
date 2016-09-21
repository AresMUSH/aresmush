module AresMUSH
  module Status
    class GoOffstageCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      
      def handle        
        char = client.char
        oocloc = Rooms::Api.ooc_room
        
        char.is_afk = false
        if (Rooms::Api.room_type(char.room) == "IC")
          char.last_ic_location_id = char.room.id
          # No need to save because we're going to do it when we move them
        end
        char.room.emit_ooc t('status.go_ooc', :name => char.name)
        oocloc.emit_ooc t('status.go_ooc', :name => char.name)
        Rooms::Api.move_to(client, client.char, oocloc)
      end
    end
  end
end
