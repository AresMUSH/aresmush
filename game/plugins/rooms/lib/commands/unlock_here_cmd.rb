module AresMUSH
  module Rooms
    class UnlockHereCmd
      include CommandHandler
      include CommandRequiresLogin
      
      def check_is_interior_room
        target = enactor_room.way_in
        return t('rooms.cant_lock_exterior_rooms') if !target
        return nil if target.lock_keys.empty?
        return t('rooms.already_has_lock') if target.lock_keys != Rooms.interior_lock
        return nil
      end
      
      def handle
        target = enactor_room.way_in
        target.lock_keys = []
        target.save
        client.emit_success t('rooms.way_in_unlocked')
      end
    end
  end
end
