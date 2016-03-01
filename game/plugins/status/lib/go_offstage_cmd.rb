module AresMUSH
  module Status
    class GoOffstageCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      
      def want_command?(client, cmd)
        cmd.root_is?("offstage") && cmd.args.nil?
      end
      
      def handle        
        char = client.char
        oocloc = Game.master.ooc_room
        
        char.is_afk = false
        if (char.room.room_type == "IC")
          char.last_ic_location_id = char.room.id
          # No need to save because we're going to do it when we move them
        end
        char.room.emit_ooc t('status.go_ooc', :name => char.name)
        oocloc.emit_ooc t('status.go_ooc', :name => char.name)
        Rooms.move_to(client, client.char, oocloc)
      end
    end
  end
end
