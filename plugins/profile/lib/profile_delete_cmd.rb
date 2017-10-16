module AresMUSH
  module Profile
    class ProfileDeleteCmd
      include CommandHandler
      
      attr_accessor :field
     
      def parse_args
        self.field = titlecase_arg(cmd.args)
      end
      
      def required_args
        [ self.field ]
      end
      
      def handle
        profile = enactor.profile
        profile.delete self.field
        enactor.set_profile(profile)
        client.emit_success t('profile.custom_profile_cleared', :field => self.field)
      end
    end
  end
end