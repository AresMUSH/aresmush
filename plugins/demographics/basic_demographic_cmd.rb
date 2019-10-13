module AresMUSH
  module Demographics

    class BasicDemographicCmd
      include CommandHandler
      
      attr_accessor :name, :value, :property

      def parse_args
        # Admin version
        if (Demographics.can_set_demographics?(enactor) && cmd.args =~ /\//)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_optional_arg3)
          
          self.property = downcase_arg(args.arg2)

          # If the first part after the / isn't a demographic name then this isn't an admin
          # command after all - it's just a demographic with a slash in the value.
          if (Global.read_config("demographics", "demographics").include?(self.property))
            self.name = titlecase_arg(args.arg1)
            self.value = titlecase_arg(args.arg3)
          else
            args = cmd.parse_args(ArgParser.arg1_equals_arg2)
            self.name = enactor_name
            self.property = downcase_arg(args.arg1)
            self.value = titlecase_arg(args.arg2)
          end
            
        # Self version
        else
          args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
          self.name = enactor_name
          self.property = downcase_arg(args.arg1)
          self.value = titlecase_arg(args.arg2)
        end
      end
      
      def required_args
        [ self.name, self.property ]
      end
     
      def check_is_allowed
        return nil if self.name == enactor_name
        return t('dispatcher.not_allowed') if !Demographics.can_set_demographics?(enactor)
        return nil
      end

      def check_property
        bday = [ "age", "birthdate", "birthday"]
        return t('demographics.use_birthday_instead') if bday.include?(self.property)
        return t('demographics.invalid_demographic') if !Demographics.all_demographics.include?(self.property)
        return nil
      end
      
      def check_chargen_locked
        return nil if Demographics.can_set_demographics?(enactor)
        enabled_after_cg = Global.read_config("demographics", "editable_properties")
        return nil if enabled_after_cg.include?(self.property)
        Chargen.check_chargen_locked(enactor)
      end
         
      def check_gender
        return nil if self.property != "gender"
        
        genders = Demographics.genders
        return nil if genders.include?(self.value)
        return t('demographics.invalid_gender', :genders => genders.join(', '))
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          
          model.update_demographic(self.property, self.value)
          
          if (self.name == enactor_name)
            client.emit_success t('demographics.property_set', :property => self.property, :value => self.value)
          else
            client.emit_success t('demographics.admin_property_set', :name => self.name, :property => self.property, :value => self.value)
          end
        end
      end
    end
  end
end