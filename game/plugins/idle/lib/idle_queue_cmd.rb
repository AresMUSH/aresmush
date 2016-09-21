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
        client.emit Idle.print_idle_queue(client)
      end
    end
  end
end
