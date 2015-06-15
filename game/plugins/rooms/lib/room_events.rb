module AresMUSH
  module Rooms
    class LoginEvents
      include Plugin

      def on_char_connected_event(event)
        client = event.client
        Rooms.emit_here_desc(client)
      end
      
      def on_char_disconnected_event(event)
        client = event.client
        if (client.char.is_guest?)
          Rooms.move_to(client, client.char, Game.master.welcome_room)
        end
      end
      
      def on_cron_event(event)
        config = Global.read_config("rooms", "room_lock_cron")
        return if !Cron.is_cron_match?(config, event.time)

        locked_exits = Exit.all.select { |e| !e.lock_keys.empty?}
        locked_exits.each do |e|
          if (e.dest.characters.count == 0)
            Global.logger.debug "Unlocking #{e.name} automatically."
            e.lock_keys = []
            e.save!
          end
        end
      end
      
    end
  end
end
