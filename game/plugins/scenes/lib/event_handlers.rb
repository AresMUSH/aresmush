module AresMUSH
  module Scenes
    
    class GameStartedEventHandler
      def on_event(event)
        Pose.reset_reposes
      end
    end
    
    class CharConnectedEventHandler
      def on_event(event)
        if (event.char.repose_nudge_muted)
          event.char.update(repose_nudge_muted: false)
        end
      end
    end
    
    
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("scenes", "cron")
        return if !Cron.is_cron_match?(config, event.time)
        
        Pose.reset_reposes
        
        rooms = Room.all.select { |r| !!r.scene_set || !!r.scene }
        rooms.each do |r|
          if (r.clients.empty? && r.scene_set)
            Global.logger.debug("Clearing scene set on #{r.name}")
            r.update(scene_set: nil)
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