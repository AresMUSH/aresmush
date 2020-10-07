module AresMUSH

  module Idle
    class IdleExecuteCmd
      include CommandHandler
      
      def check_can_manage
        return nil if Idle.can_idle_sweep?(enactor)
        return t('dispatcher.not_allowed')
      end
      
      def check_idle_in_progress
        return t('idle.idle_not_started') if !client.program[:idle_queue]
        return nil
      end
      
      def handle
        queue =  client.program[:idle_queue]

        report = Idle.execute_idle_sweep(enactor, queue)
        template = BorderedDisplayTemplate.new report
        client.emit template.render
      
        client.program.delete(:idle_queue)
          
      end      
    end
  end
end
