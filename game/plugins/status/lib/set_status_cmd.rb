module AresMUSH
  module Status
    class SetStatusCmd
      include Plugin
      include PluginRequiresLogin
      include PluginWithoutSwitches
      include PluginRequiresArgs

      attr_accessor :status
      
      def initialize
        self.required_args = ['status']
        self.help_topic = 'status'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("status")
      end
      
      def crack!
        self.status = cmd.args.nil? ? nil : trim_input(cmd.args.upcase)
      end
      
# TODO: Disabled temporarily for testing
#      def check_can_set_status
#        return t('status.newbies_cant_change_status') if !client.char.is_approved?
#        return nil
#      end
      
      def check_status
# TODO: 'NEW' should not be in this list.  Added temporarily for testing.        
        status_vals = [ "ADM", "IC", "OOC", "AFK", "NEW" ]
        return t('status.invalid_status') if !status_vals.include?(self.status)
        return nil
      end
      
      def check_can_be_on_duty
        return t('status.cannot_set_on_duty') if (self.status == "ADM" && !Status.can_be_on_duty?(client.char))
        return nil
      end
      
      def handle        
        Status.set_status(client.char, self.status) 
        char = client.char
        char.room.emit_ooc t('status.status_change', 
          :name => char.name, 
          :pronoun => char.possessive_pronoun, 
          :status => status)       
      end
    end
  end
end
