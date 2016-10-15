module AresMUSH

  module FS3Skills
    class SetAbilityCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      include CommandWithoutSwitches
      
      attr_accessor :name, :ability_name, :rating
      
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

      def required_args
        {
          args: [ self.name, self.ability_name, self.rating ],
          help: 'abilities'
        }
      end
      
      def check_valid_rating
        return nil if !self.rating
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
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|        
          FS3Skills.set_ability(client, model, self.ability_name, self.rating.to_i)
        end
      end
    end
  end
end
