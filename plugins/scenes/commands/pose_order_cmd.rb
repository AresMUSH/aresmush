module AresMUSH
  module Scenes
    class PoseOrderCmd
      include CommandHandler
      
      def handle
        poses = enactor_room.sorted_pose_order
        list = poses.map { |name, time| "#{name.ljust(30)} #{last_posed(time)}"}

        template = BorderedListTemplate.new list, t('scenes.pose_order_title')
        client.emit template.render
      end
      
      def last_posed(time)
        TimeFormatter.format(Time.now - Time.parse(time))
      end
    end
  end
end
