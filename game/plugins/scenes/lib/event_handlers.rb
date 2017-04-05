module AresMUSH
  module Scenes
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("scenes", "cron")
        #return if !Cron.is_cron_match?(config, event.time)
        
        rooms = Room.all.select { |r| !!r.scene_set }
        rooms.each do |r|
          if (r.clients.empty?)
            r.update(scene_set: nil)
          end
        end
      end
    end
  end
end