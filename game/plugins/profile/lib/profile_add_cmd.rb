module AresMUSH
  module Profile
    class ProfileAddCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :field, :value

      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.field = titleize_input(cmd.args.arg1)
        self.value = cmd.args.arg2
      end
      
      def required_args
        {
          args: [ self.field, self.value ],
          help: 'profile'
        }
      end
      
      def handle
        enactor.profile[self.field] = self.value
        enactor.save
        client.emit_success t('profile.custom_profile_set', :field => self.field)
      end
    end
  end
end