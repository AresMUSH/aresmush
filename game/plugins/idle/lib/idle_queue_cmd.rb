module AresMUSH

  module Idle
    class IdleQueueCmd
      include CommandHandler
      include CommandWithoutArgs
      
      def check_idle_in_progress
        return t('idle.idle_not_started') if !client.program[:idle_queue]
        return nil
      end
      
      def handle
        template = IdleQueueTemplate.new(client.program[:idle_queue], enactor)
        client.emit template.render
      end
    end
  end
end
