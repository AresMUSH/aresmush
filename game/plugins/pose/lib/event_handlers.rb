module AresMUSH
  module Pose
    class CharCreatedEventHandler
      def on_event(event)
        prefs = PosePrefs.create(character: event.char, autospace: "%r")
        event.char.update(pose_prefs: prefs)
      end
    end
    
    class GameStartedEventHandler
      def on_event(event)
        Pose.reset_reposes
      end
    end
    
    class CronEventHandler
      def on_event(event)
        config = Global.read_config("pose", "cron")
        return if !Cron.is_cron_match?(config, event.time)

        Pose.reset_reposes
      end
    end
  end
end