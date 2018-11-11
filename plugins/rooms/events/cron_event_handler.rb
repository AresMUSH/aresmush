module AresMUSH
  module Rooms
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("rooms", "room_lock_cron")
        return if !Cron.is_cron_match?(config, event.time)

        Global.logger.debug "Cleaning up locked exits."

        locked_exits = Exit.all.select { |e| !e.lock_keys.empty?}
        locked_exits.each do |e|
          if (e.dest.clients.count == 0)
            Global.logger.debug "Unlocking #{e.name} automatically."
            e.update(lock_keys: [])
          end
        end
      end
      
    end
  end
end
