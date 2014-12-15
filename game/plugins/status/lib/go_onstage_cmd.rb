module AresMUSH
  module Status
    class GoOnstageCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutArgs
      
      def want_command?(client, cmd)
        cmd.root_is?("onstage") && (cmd.switch.nil? || cmd.switch_is?("reset"))
      end
      
      def check_can_set_status
        return nil if Status.can_manage_status?(client.char)
        return t('status.newbies_cant_go_ic') if !client.char.is_approved
        return nil
      end
      
      def handle        
        char = client.char
        icloc = get_icloc(char)
        char.is_afk = false
        # No need to save because move will do it.
        char.room.emit_ooc t('status.go_ic', :name => char.name)
        icloc.emit_ooc t('status.go_ic', :name => char.name)
        Rooms.move_to(client, client.char, icloc)
      end
      
      def get_icloc(char)
        icloc_id = char.last_ic_location_id
        ic_start_room = Game.master.ic_start_room
        icloc = ic_start_room
        if (!icloc_id.nil? && !cmd.switch_is?("reset"))
          icloc = Room.find(icloc_id)
        end
        icloc || ic_start_room
      end
        
    end
  end
end
