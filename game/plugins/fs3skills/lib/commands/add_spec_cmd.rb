module AresMUSH

  module FS3Skills
    class AddSpecialtyCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :name, :specialty
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.name = titleize_input(cmd.args.arg1)
        self.specialty = titleize_input(cmd.args.arg2)
      end

      def required_args
        {
          args: [ self.name, self.specialty ],
          help: 'abilities'
        }
      end
      
      def check_name_for_dots
        return t('fs3skills.no_special_characters') if (self.specialty !~ /^[\w\s]+$/)
        return nil
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
        
        if (!config['specialties'].include?(self.specialty))     
          client.emit_failure t('fs3skills.invalid_specialty', :names => config['specialties'].join(", "))
          return
        end
        
        if (ability.specialties.include?(self.specialty))
          client.emit_failure t('fs3skills.specialty_already_exists')
          return
        end
        
        specs = ability.specialties
        specs << self.specialty
        ability.update(specialties: specs)
        client.emit_success t('fs3skills.specialty_added', :name => self.specialty)
      end
    end
  end
end
