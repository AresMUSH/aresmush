module AresMUSH
  module Rooms
    class ICStartCmd
      include CommandHandler

      attr_accessor :dest

      def parse_args
        self.dest = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.dest ]
      end
      
      def check_can_build
        return t('dispatcher.not_allowed') if !Rooms.can_build?(enactor)
        return nil
      end
      
      def handle
        matched_rooms = Room.find_by_name_and_area self.dest, enactor_room
        if (matched_rooms.count != 1)
          client.emit_failure matched_rooms.count == 0 ? t('db.object_not_found') : t('db.object_ambiguous')
          return
        end
        room = matched_rooms.first
        
        Game.master.update(ic_start_room: room)        
        client.emit_success t('rooms.ic_start_set', :name => room.name)
      end
    end
  end
end
