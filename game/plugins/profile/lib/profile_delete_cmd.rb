module AresMUSH
  module Profile
    class ProfileDeleteCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :field
     
      def crack!
        self.field = titleize_input(cmd.args)
      end
      
      def required_args
        {
          args: [ self.field ],
          help: 'profile'
        }
      end
      
      def handle
        enactor.profile.delete self.field
        enactor.save
        client.emit_success t('profile.custom_profile_cleared', :field => self.field)
      end
    end
  end
end