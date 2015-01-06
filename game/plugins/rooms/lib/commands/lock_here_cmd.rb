module AresMUSH
  module Rooms
    class LockHereCmd
      include Plugin
      include PluginRequiresLogin
      
      def want_command?(client, cmd)
        cmd.root_is?("lock") && cmd.args.nil?
      end

      def check_is_interior_room
        target = client.room.way_in
        return t('rooms.cant_lock_exterior_rooms') if !target
        return t('rooms.already_has_lock') if !target.lock_keys.empty?
        return nil
      end
      
      def handle
        target = client.room.way_in
        target.lock_keys = Rooms.interior_lock
        target.save!
        client.emit_success t('rooms.way_in_locked')
      end
    end
  end
end
