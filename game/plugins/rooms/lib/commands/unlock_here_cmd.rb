module AresMUSH
  module Rooms
    class UnlockHereCmd
      include Plugin
      include PluginRequiresLogin
      
      def want_command?(client, cmd)
        cmd.root_is?("unlock") && cmd.args.nil?
      end

      def check_is_interior_room
        target = client.room.way_in
        return t('rooms.cant_lock_exterior_rooms') if !target
        return nil if target.lock_keys.empty?
        return t('rooms.already_has_lock') if target.lock_keys != Rooms.interior_lock
        return nil
      end
      
      def handle
        target = client.room.way_in
        target.lock_keys = []
        target.save!
        client.emit_success t('rooms.way_in_unlocked')
      end
    end
  end
end
