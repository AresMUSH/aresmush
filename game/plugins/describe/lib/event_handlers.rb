module AresMUSH
  module Describe
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("describe", "cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        Describe.rooms_with_scenes.each do |r|
          if (r.clients.empty? || (Time.now - r.scene_set.time > 28800))
            Global.logger.debug "Clearing sceneset from #{r.name}."
            r.scene_set.delete
          end
        end
      end
    end
  end
end