module AresMUSH
  module Demographics

    class BirthdateCmd
      include CommandHandler
      
      attr_accessor :name, :date_str
            
      def parse_args
        # Admin version
        if (Demographics.can_set_demographics?(enactor) && cmd.args =~ /\=/)
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.name = titlecase_arg(args.arg1)
          self.date_str = args.arg2
          # Self version
        else
          self.name = enactor.name
          self.date_str = cmd.args
        end
      end
      
      def required_args
        [ self.name, self.date_str ]
      end
                
      def check_is_allowed
        return nil if self.name == enactor_name
        return t('dispatcher.not_allowed') if !Demographics.can_set_demographics?(enactor)
        return nil
      end
      
      def check_chargen_locked
        Chargen.check_chargen_locked(enactor)
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          begin
            bday = Date.strptime(self.date_str, Global.read_config("datetime", "short_date_format"))
          rescue
            client.emit_failure t('demographics.invalid_birthdate', 
            :format_str => Global.read_config("datetime", "date_entry_format_help"))
            return
          end
        
          age = Demographics.calculate_age(bday)
          model.update_demographic(:birthdate, bday)

          if (self.name == enactor_name)
            client.emit_success t('demographics.birthdate_set', 
            :birthdate => ICTime.ic_datestr(bday), 
            :age => model.age)
          else
            client.emit_success t('demographics.admin_property_set', :name => self.name, :property => "birthdate", :value => self.date_str)
          end
        end
        
      end
    
    end
  end
end