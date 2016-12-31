module AresMUSH
  module Profile
    class ProfileAddCmd
      include CommandHandler
      
      attr_accessor :field, :value

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.field = titlecase_arg(args.arg1)
        self.value = args.arg2
      end
      
      def required_args
        {
          args: [ self.field, self.value ],
          help: 'profile'
        }
      end
      
      def handle
        field = ProfileField.find(name: self.field).combine(character_id: enactor.id).first
        if (field)
          field.update(data: self.value)
        else
          ProfileField.create(character: enactor, name: self.field, data: self.value)
        end
        client.emit_success t('profile.custom_profile_set', :field => self.field)
      end
    end
  end
end