module AresMUSH
  module Profile
    class ProfileAddCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :field, :value
     
      def initialize
        self.required_args = ['field', 'value']
        self.help_topic = 'profile'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("profile") && cmd.switch_is?("add")
      end

      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.field = titleize_input(cmd.args.arg1)
        self.value = cmd.args.arg2
      end
      
      def handle
        client.char.profile[self.field] = self.value
        client.char.save!
        client.emit_success t('handles.custom_profile_set', :field => self.field)
      end
    end
  end
end