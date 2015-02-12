module AresMUSH
  module Pose_History   
    class PoseHistoryCronHandler
      include Plugin
      
      def on_cron_event(event)
        config = Global.config['pose_history']['cron']
        return if !Cron.is_cron_match?(config, event.time)
        
        # Remove any pose with a timestamp longer than an hour
        pose_history.each do |room, value|
          value.each do |time|
            if time + 3600 > time.now
              pose_history[room].delete(time)
            end
          end
        end
      end
    end    
  end
end