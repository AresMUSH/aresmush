module AresMUSH
  module Profile
    class ProfileAddCmd
      include CommandHandler
      
      attr_accessor :field, :value

      def crack!
        cmd.crack_args!(ArgParser.arg1_equals_arg2)
        self.field = titleize_input(cmd.args.arg1)
        self.value = cmd.args.arg2
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