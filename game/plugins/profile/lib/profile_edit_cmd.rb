module AresMUSH
  module Profile
    class ProfileEditCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :field

      def initialize(client, cmd, enactor)
        self.required_args = ['field']
        self.help_topic = 'profile'
        super
      end
            
      def crack!
        self.field = titleize_input(cmd.args)
      end
      
      def handle
        Utils::Api.grab client, "profile/set #{self.field}=#{enactor.profile[self.field]}"
      end
        
    end
  end
end
