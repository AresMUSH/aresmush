module AresMUSH

  module Idle
    class IdleQueueCmd
      include CommandHandler
      
      def check_idle_in_progress
        return t('idle.idle_not_started') if !client.program[:idle_queue]
        return nil
      end
      
      def check_can_manage
        return nil if Idle.can_idle_sweep?(enactor)
        return t('dispatcher.not_allowed')
      end
      
      def handle
        template = IdleQueueTemplate.new(client.program[:idle_queue], enactor)
        client.emit template.render
      end
    end
  end
end
