module AresMUSH
  module Rooms
    class LockHereCmd
      include CommandHandler
      include CommandRequiresLogin      

      def check_is_interior_room
        target = enactor_room.way_in
        return t('rooms.cant_lock_exterior_rooms') if !target
        return t('rooms.already_has_lock') if !target.lock_keys.empty?
        return nil
      end
      
      def handle
        target = enactor_room.way_in
        target.lock_keys = Rooms.interior_lock
        target.save!
        client.emit_success t('rooms.way_in_locked')
      end
    end
  end
end
