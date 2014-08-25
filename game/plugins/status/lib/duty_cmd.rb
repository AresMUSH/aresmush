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
        self.status = cmd.args.nil? ? nil : trim_input(cmd.args).downcase
      end
      
      def check_can_manage_status
        return t('status.cannot_set_on_duty') if !Status.can_manage_status?(client.char)
        return nil
      end
      
      def check_status
        values = ['on', 'off']
        return t('dispatcher.invalid_on_off_option') if !values.include?(self.status)
      end
      
      def handle        
        client.char.is_afk = false
        client.char.is_on_duty = (self.status == "on")
        client.char.save
        client.emit_ooc t('status.set_duty', :value => self.status)
      end
    end
  end
end
