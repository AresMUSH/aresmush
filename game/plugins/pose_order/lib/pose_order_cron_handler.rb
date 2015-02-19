module AresMUSH
  module Pose_Order    
    class PoseOrderCronHandler
      include Plugin
      
      def on_cron_event(event)
        config = Global.config['pose_order']['cron']
        return if !Cron.is_cron_match?(config, event.time)
                
        # Iterate over po hash and remove anything over an hour old.
        #Pose_Order.po.each do |key, value|
         # value.each do |k,v|
          #  if v[:time] < Time.now.to_i - 60
           #   po[key].delete(k)
            #end
          #end
        #end
      end
    end
  end
end
