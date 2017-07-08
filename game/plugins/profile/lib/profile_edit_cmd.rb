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
        value = enactor.profile[self.field]
        text = value || ""
        
        Utils.grab client, enactor, "profile/set #{self.field}=#{text}"
      end
        
    end
  end
end
