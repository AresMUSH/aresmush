module AresMUSH

  module Idle
    class LastWillCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :will   
      
      def crack!
        self.will = cmd.args
      end
      
      def required_args
        {
          args: [ self.will ],
          help: 'lastwill'
        }
      end
      
      def handle
        enactor.update(idle_lastwill: self.will)
        client.emit_success t('idle.lastwill_set')
      end
    end
  end
end
