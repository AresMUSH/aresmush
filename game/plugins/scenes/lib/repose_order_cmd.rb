module AresMUSH
  module Scenes
    class ReposeOrderCmd
      include CommandHandler
      
      def handle
        if (!enactor.room.repose_on?)
          client.emit_failure t('pose.repose_off')
          return
        end
        
        repose = enactor.room.repose_info
        poses = repose.sorted_orders
        list = poses.map { |p| "#{p.character.name.ljust(30)} #{last_posed(p.time)}"}

        template = BorderedListTemplate.new list, t('pose.repose_order_title')
        client.emit template.render
      end
      
      def last_posed(time)
        TimeFormatter.format(Time.now - time)
      end
    end
  end
end
