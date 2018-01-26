module AresMUSH

  module Idle
    class LastWillCmd
      include CommandHandler
      
      attr_accessor :will   
      
      def parse_args
        self.will = cmd.args
      end
      
      def handle
        if (self.will)
          enactor.update(idle_lastwill: self.will)
          client.emit_success t('idle.lastwill_set')
        else
          if (enactor.idle_lastwill)
            client.emit_ooc t('idle.lastwill', :will => enactor.idle_lastwill)
          else
            client.emit_ooc t('idle.lastwill_not_set')
          end
        end
      end
    end
  end
end
