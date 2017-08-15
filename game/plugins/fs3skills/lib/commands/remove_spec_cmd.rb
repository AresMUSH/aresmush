module AresMUSH

  module FS3Skills
    class RemoveSpecialtyCmd
      include CommandHandler
      
      attr_accessor :name, :specialty
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.specialty = titlecase_arg(args.arg2)
      end

      def required_args
        [ self.name, self.specialty ]
      end
      
      def handle
        ability = FS3Skills.find_ability(enactor, self.name)
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
          client.emit_failure t('fs3skills.specialty_not_found')
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
