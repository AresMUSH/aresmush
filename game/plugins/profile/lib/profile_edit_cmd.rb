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
        field = ProfileField.find(name: self.field).first
        text = field ? field.data : ""
        
        Utils::Api.grab client, enactor, "profile/set #{self.field}=#{text}"
      end
        
    end
  end
end
