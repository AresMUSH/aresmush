module AresMUSH
  module Pose
    class ReposeOrderCmd
      include CommandHandler
      include CommandRequiresLogin
      
      def handle
        repose = enactor.room.repose_info
        if (!repose)
          client.emit_failure t('pose.repose_disabled')
          return
        end
        
        poses = repose.pose_orders.to_a.sort { |p1, p2| p1.time <=> p2.time }.reverse
        list = poses.map { |p| "#{p.character.name.ljust(30)} #{last_posed(p.time)}"}
        client.emit BorderedDisplay.list list, t('pose.repose_order_title')
      end
      
      def last_posed(time)
        TimeFormatter.format(Time.now - time)
      end
    end
  end
end
