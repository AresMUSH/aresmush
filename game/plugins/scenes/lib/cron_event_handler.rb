module AresMUSH
  module Scenes
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("scenes", "cron")
        return if !Cron.is_cron_match?(config, event.time)
                
        rooms = Room.all.select { |r| !!r.scene_set || !!r.scene || !r.scene_nag}
        rooms.each do |r|
          if (r.clients.empty?)
            if (r.scene_set)
              r.update(scene_set: nil)
            end
            
            if (!r.scene_nag)
              r.update(scene_nag: true)
            end
          end
          
          if (r.characters.empty? && r.scene)
            Global.logger.debug("Stopping scene in #{r.name}")
            Scenes.stop_scene(r.scene)
          end
        end
      end
    end
  end
end