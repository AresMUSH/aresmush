module AresMUSH
  module Scenes
    class PoseOrderCmd
      include CommandHandler
      
      def handle
        poses = enactor_room.sorted_pose_order
        list = poses.map { |name, time| "#{name.ljust(30)} #{last_posed(time)}"}

        notice = enactor_room.pose_order_type == '3per' ? "%xg#{t('scenes.pose_threeper_notice')}%xn" : nil
        template = BorderedListTemplate.new list, t('scenes.pose_order_title'), notice
        client.emit template.render
      end
      
      def last_posed(time)
        TimeFormatter.format(Time.now - Time.parse(time))
      end
    end
  end
end
