module AresMUSH
  module Rooms
    class CharConnectedEventHandler
      def on_event(event)
        Rooms.emit_here_desc(event.client, event.char)
      end
    end
    
    class CharDisconnectedEventHandler      
      def on_event(event)
        client = event.client
        if (Login::Api.is_guest?(event.char))
          Rooms.move_to(client, event.char, Game.master.welcome_room)
        end
      end  
    end
    
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("rooms", "room_lock_cron")
        return if !Cron.is_cron_match?(config, event.time)

        locked_exits = Exit.all.select { |e| !e.lock_keys.empty?}
        locked_exits.each do |e|
          if (e.dest.characters.count == 0)
            Global.logger.debug "Unlocking #{e.name} automatically."
            e.lock_keys = []
            e.save
          end
        end
      end
      
    end
  end
end
