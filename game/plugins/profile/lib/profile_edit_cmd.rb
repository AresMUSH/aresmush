module AresMUSH
  module Profile
    class ProfileEditCmd
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
        Utils::Api.grab client, "profile/set #{self.field}=#{enactor.profile[self.field]}"
      end
        
    end
  end
end
