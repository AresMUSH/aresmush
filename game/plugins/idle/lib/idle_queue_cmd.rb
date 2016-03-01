module AresMUSH

  module Idle
    class IdleQueueCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      
      def want_command?(client, cmd)
        cmd.root_is?("idle") && cmd.switch_is?("queue")
      end
      
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
