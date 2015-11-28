module AresMUSH
  module Profile
    class ProfileEditCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :field

      def initialize
        self.required_args = ['field']
        self.help_topic = 'profile'
        super
      end
            
      def want_command?(client, cmd)
        cmd.root_is?("profile") && cmd.switch_is?("edit")
      end

      def crack!
        self.field = titleize_input(cmd.args)
      end
      
      def handle
        client.grab "profile/set #{self.field}=#{client.char.profile[self.field]}"
      end
        
    end
  end
end
