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
        enactor.lastwill = self.will
        enactor.save
        client.emit_success t('idle.lastwill_set')
      end
    end
  end
end
