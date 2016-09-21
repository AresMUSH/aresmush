module AresMUSH
  module Status
    class DutyCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandRequiresArgs
      
      attr_accessor :status
      
      def initialize
        self.required_args = ['status']
        self.help_topic = 'duty'
        super
      end
      
      def crack!
        self.status = OnOffOption.new(cmd.args)
      end
      
      def check_can_be_on_duty
        return t('status.cannot_set_on_duty') if !Status.can_be_on_duty?(client.char)
        return nil
      end
      
      def check_status
        return self.status.validate
      end
      
      def handle        
        client.char.is_afk = false
        client.char.is_on_duty = self.status.is_on?
        client.char.save
        client.emit_ooc t('status.set_duty', :value => self.status)
      end
    end
  end
end
