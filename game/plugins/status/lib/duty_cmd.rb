module AresMUSH
  module Status
    class DutyCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandRequiresArgs
      
      attr_accessor :status
      
      def crack!
        self.status = OnOffOption.new(cmd.args)
      end
      
      def required_args
        {
          args: [ self.status ],
          help: 'duty'
        }
      end
      
      def check_can_be_on_duty
        return t('status.cannot_set_on_duty') if !Status.can_be_on_duty?(enactor)
        return nil
      end
      
      def check_status
        return self.status.validate
      end
      
      def handle        
        enactor.update(is_on_duty: self.status.is_on?)
        client.emit_ooc t('status.set_duty', :value => self.status)
      end
    end
  end
end
