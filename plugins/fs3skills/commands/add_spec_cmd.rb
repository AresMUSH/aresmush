module AresMUSH

  module FS3Skills
    class AddSpecialtyCmd
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
      
      def check_name_for_dots
        return t('fs3skills.no_special_characters') if (self.specialty !~ /^[\w\s]+$/)
        return nil
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
          error = FS3Skills.add_specialty(model, self.name, self.specialty)
          if (error)
            client.emit_failure error
          else
            client.emit_success t('fs3skills.specialty_added', :name => self.specialty)
          end
        end
      end
    end
  end
end
