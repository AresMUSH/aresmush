module AresMUSH

  module Idle
    class IdleStartCmd
      include CommandHandler
      
      def check_can_manage
        return nil if Idle.can_idle_sweep?(enactor)
        return t('dispatcher.not_allowed')
      end
      
      def handle
        client.program[:idle_queue] = Idle.build_idle_queue
        template = IdleQueueTemplate.new(client.program[:idle_queue], enactor)
        client.emit template.render
        
      end
    end
  end
end
