module AresMUSH
  module Demographics

    class BirthdateCmd
      include CommandHandler
      
      attr_accessor :date_str
            
      def parse_args
        self.date_str = cmd.args
      end
      
      def required_args
        {
          args: [ self.date_str ],
          help: 'demographics'
        }
      end
                
      def check_chargen_locked
        Chargen::Api.check_chargen_locked(enactor)
      end
      
      def handle
        begin
          bday = Date.strptime(self.date_str, Global.read_config("date_and_time", "short_date_format"))
        rescue
          client.emit_failure t('demographics.invalid_birthdate', 
            :format_str => Global.read_config("date_and_time", "date_entry_format_help"))
          return
        end
        
        age = Demographics.calculate_age(bday)
        age_error = Demographics.check_age(age)
        
        if (age_error)
          client.emit_failure age_error
          return
        end
        
        demographics = enactor.get_or_create_demographics
        demographics.update(birthdate: bday)
        
        client.emit_success t('demographics.birthdate_set', 
          :birthdate => ICTime::Api.ic_datestr(bday), 
          :age => enactor.age)
      end
        
    end
    
  end
end