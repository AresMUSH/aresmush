module AresMUSH

  module FS3Skills
    class SetAbilityCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      include CommandWithoutSwitches
      
      attr_accessor :name, :ability_name, :rating

      def initialize(client, cmd, enactor)
        self.required_args = ['name', 'ability_name', 'rating']
        self.help_topic = 'abilities'
        super
      end
      
      def crack!
        if (cmd.args =~ /[^\/]+\=.+\/.+/)
          cmd.crack_args!(CommonCracks.arg1_equals_arg2_slash_arg3)
          self.name = trim_input(cmd.args.arg1)
          self.ability_name = titleize_input(cmd.args.arg2)
          self.rating = trim_input(cmd.args.arg3)
        else
          cmd.crack_args!(CommonCracks.arg1_equals_arg2)
          self.name = enactor_name
          self.ability_name = titleize_input(cmd.args.arg1)
          self.rating = trim_input(cmd.args.arg2)
        end
      end
      
      def check_ability_type
        ability_type = FS3Skills.get_ability_type(enactor, self.ability_name)
        valid_types = [:action, :advantage]
        return t('fs3skills.wrong_type_for_ability_command') if !valid_types.include?(ability_type)
        return nil
      end
      
      def check_advantages_enabled
        ability_type = FS3Skills.get_ability_type(enactor, self.ability_name)
        return t('fs3skills.advantages_not_enabled') if (ability_type == :advantage && !FS3Skills.advantages_enabled?)
        return nil
      end
      
      def check_valid_rating
        return nil if self.rating.nil?
        return t('fs3skills.invalid_rating') if !self.rating.is_integer?
        return nil
      end
      
      def check_can_set
        return nil if enactor_name == self.name
        return nil if FS3Skills.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end      
      
      def check_chargen_locked
        return nil if FS3Skills.can_manage_abilities?(enactor)
        Chargen::Api.check_chargen_locked(enactor)
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
