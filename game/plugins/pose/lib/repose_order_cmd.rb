module AresMUSH
  module Pose
    class ReposeOrderCmd
      include CommandHandler
      include CommandRequiresLogin
      
      def handle
        room = client.char.room
        if (!Pose.repose_on(room))
          client.emit_failure t('pose.repose_disabled')
          return
        end
        
        poses = room.pose_order.sort_by { |k, v| v }.reverse
        list = poses.map { |n, v| "#{n.ljust(30)} #{last_posed(v)}"}
        client.emit BorderedDisplay.list list, t('pose.repose_order_title')
      end
      
      def last_posed(time)
        TimeFormatter.format(Time.now - time)
      end
    end
  end
end
