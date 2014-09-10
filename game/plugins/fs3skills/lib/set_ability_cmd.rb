module AresMUSH

  module FS3Skills
    class SetAbilityCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      include PluginWithoutSwitches
      
      attr_accessor :name, :rating

      def initialize
        self.required_args = ['name', 'rating']
        self.help_topic = 'skills'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("ability")
      end

      def crack!
        cmd.crack!(CommonCracks.arg1_equals_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.rating = trim_input(cmd.args.arg2)
      end
      
      def check_valid_rating
        return nil if self.rating.nil?
        return t('fs3skills.invalid_rating') if !self.rating.is_integer?
        return nil
      end
      
      def handle
        FS3Skills.set_ability(client, client.char, self.name, self.rating.to_i)
      end
    end
  end
end
