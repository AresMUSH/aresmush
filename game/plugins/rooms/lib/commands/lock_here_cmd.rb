module AresMUSH
  module Rooms
    class LockHereCmd
      include CommandHandler

      def check_is_interior_room
        target = enactor_room.way_in
        return t('rooms.cant_lock_exterior_rooms') if !target
        return t('rooms.cant_lock_exterior_rooms') if enactor_room.exits.count > 1
        return t('rooms.already_has_lock') if !target.lock_keys.empty?
        return nil
      end
      
      def handle
        
        enactor_room.way_in.update(lock_keys: Rooms.interior_lock)
        client.emit_success t('rooms.way_in_locked')
      end
    end
  end
end
