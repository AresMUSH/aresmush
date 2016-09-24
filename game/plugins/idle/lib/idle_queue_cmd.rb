module AresMUSH

  module Idle
    class IdleQueueCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      
      def check_idle_in_progress
        queue = client.program[:idle_queue]
        return t('idle.idle_not_started') if !queue
        return nil
      end
      
      def handle
        queue = client.program[:idle_queue]
        if (!queue)
          client.emit_failure t('idle.idle_not_started')
          return
        end
        
        template = IdleQueueTemplate.new(queue, client)
        client.emit template.render
      end
    end
  end
end
