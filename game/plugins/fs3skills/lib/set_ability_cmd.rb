module AresMUSH

  module FS3Skills
    class SetAbilityCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      include PluginWithoutSwitches
      
      attr_accessor :name, :ability_name, :rating

      def initialize
        self.required_args = ['name', 'ability_name', 'rating']
        self.help_topic = 'skills'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("ability")
      end

      def crack!
        if (cmd.args =~ /[^\/]+\=.+\/.+/)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2_slash_arg3)
          self.name = trim_input(cmd.args.arg1)
          self.ability_name = titleize_input(cmd.args.arg2)
          self.rating = trim_input(cmd.args.arg3)
        else
          cmd.crack_args!(CommonCracks.arg1_equals_arg2)
          self.name = client.name
          self.ability_name = titleize_input(cmd.args.arg1)
          self.rating = trim_input(cmd.args.arg2)
        end
      end
      
      def check_valid_rating
        return nil if self.rating.nil?
        return t('fs3skills.invalid_rating') if !self.rating.is_integer?
        return nil
      end
      
      def check_can_set
        return nil if client.name == self.name
        return nil if FS3Skills.can_manage_abilities?(client.char)
        return t('dispatcher.not_allowed')
      end
      
      def check_approval
        return nil if FS3Skills.can_manage_abilities?(client.char)
        return t('fs3skills.cant_be_changed') if client.char.is_approved
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |model|        
          FS3Skills.set_ability(client, model, self.ability_name, self.rating.to_i)
          model.save
        end
      end
    end
  end
end
