module AresMUSH
  module Profile
    class ProfileDeleteCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :field
     
      def initialize
        self.required_args = ['field']
        self.help_topic = 'profile'
        super
      end
      
      def crack!
        self.field = titleize_input(cmd.args)
      end
      
      def handle
        client.char.profile.delete self.field
        client.char.save!
        client.emit_success t('profile.custom_profile_cleared', :field => self.field)
      end
    end
  end
end