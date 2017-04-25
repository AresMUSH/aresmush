module AresMUSH
  module Pose
    class ReposeOrderCmd
      include CommandHandler
      
      def handle
        if (!enactor.room.repose_on?)
          client.emit_failure t('pose.repose_disabled')
          return
        end
        
        repose = enactor.room.repose_info
        poses = repose.sorted_orders
        list = poses.map { |p| "#{p.character.name.ljust(30)} #{last_posed(p.time)}"}
        client.emit BorderedDisplay.list list, t('pose.repose_order_title')
      end
      
      def last_posed(time)
        TimeFormatter.format(Time.now - time)
      end
    end
  end
end
