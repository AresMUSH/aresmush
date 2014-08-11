module AresMUSH
  module Status
    class GoOocCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      
      def want_command?(client, cmd)
        cmd.root_is?("ooc") && cmd.args.nil?
      end
      
      def check_can_set_status
        return t('status.newbies_cant_change_status') if (client.char.status == "NEW") 
        return nil
      end
      
      def handle        
        char = client.char
        oocloc = Game.master.ooc_room
        char.room.emit_ooc t('status.go_ooc', :name => char.name)
        oocloc.emit_ooc t('status.go_ooc', :name => char.name)
        
        if (char.status == "IC")
          char.last_ic_location_id = char.room.id
          # No need to save because we're going to do it when we move them
        end
        Status.set_status(char, "OOC")        
        Rooms.move_to(client, client.char, oocloc)
      end
    end
  end
end
