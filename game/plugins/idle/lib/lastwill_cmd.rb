module AresMUSH

  module Idle
    class LastWillCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :will

      def initialize(client, cmd, enactor)
        self.required_args = ['will']
        self.help_topic = 'lastwill'
        super
      end     
      
      def crack!
        self.will = cmd.args
      end
      
      def handle
        enactor.lastwill = self.will
        enactor.save!
        client.emit_success t('idle.lastwill_set')
      end
    end
  end
end
