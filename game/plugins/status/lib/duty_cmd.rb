module AresMUSH
  module Status
    class DutyCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      include PluginRequiresArgs
      
      attr_accessor :status
      
      def initialize
        self.required_args = ['status']
        self.help_topic = 'duty'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("duty")
      end
      
      def crack!
        self.status = OnOffOption.new(cmd.args)
      end
      
      def check_can_manage_status
        return t('status.cannot_set_on_duty') if !Status.can_manage_status?(client.char)
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
