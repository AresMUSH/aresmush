module AresMUSH

  module FS3Skills
    class RemoveSpecialtyCmd
      include CommandHandler
      
      attr_accessor :name, :specialty, :target
      
      def parse_args
        
        # Admin version
        if (FS3Skills.can_manage_abilities?(enactor) && cmd.args =~ /\//)          
          args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_arg3)
          self.target = trim_arg(args.arg1)
          self.name = titlecase_arg(args.arg2)
          self.specialty = titlecase_arg(args.arg3)
        # Regular version
        else
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.name = titlecase_arg(args.arg1)
          self.specialty = titlecase_arg(args.arg2)
          self.target = enactor_name
        end
      end

      def required_args
        [ self.name, self.specialty ]
      end
      
      def check_chargen_locked
        return nil if FS3Skills.can_manage_abilities?(enactor)
        Chargen.check_chargen_locked(enactor)
      end
      
      def check_can_set
        return nil if enactor_name == self.target
        return nil if FS3Skills.can_manage_abilities?(enactor)
        return t('dispatcher.not_allowed')
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.target, client, enactor) do |model|        

          ability = FS3Skills.find_ability(model, self.name)
          if (!ability)
            client.emit_failure t('fs3skills.ability_not_found')
            return
          end
        
          config = FS3Skills.action_skill_config(name)
          if (!config || !config['specialties'])
            client.emit_failure t('fs3skills.invalid_specialty_skill')
            return
          end
        
          if (!ability.specialties.include?(self.specialty))     
            client.emit_failure t('fs3skills.specialty_not_found', :name => model.name)
            return
          end
        
          specs = ability.specialties
          specs.delete self.specialty
          ability.update(specialties: specs)
          client.emit_success t('fs3skills.specialty_removed', :name => self.specialty)
        end
      end
    end
  end
end
