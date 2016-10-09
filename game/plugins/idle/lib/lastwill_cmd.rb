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
        prefs = enactor.idle_prefs
        if (prefs)
          prefs.update(lastwill: self.will)
        else
          prefs = IdlePrefs.create(character: enactor, lastwill: self.will)
          enactor.update(idle_prefs: prefs)
        end
        client.emit_success t('idle.lastwill_set')
      end
    end
  end
end
