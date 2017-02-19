module AresMUSH
  module Profile
    class ProfileEditCmd
      include CommandHandler
      
      attr_accessor :field

      def parse_args
        self.field = titlecase_arg(cmd.args)
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
