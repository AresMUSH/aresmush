module AresMUSH
  module Demographics

    class AgeCmd
      include CommandHandler
      
      attr_accessor :age

      def required_args
        {
          args: [ self.age ],
          help: 'demographics'
        }
      end
         
      def check_age        
        return t('demographics.invalid_age') if !self.age.is_integer?
        return Demographics.check_age(self.age.to_i)
      end
      
      def check_chargen_locked
        Chargen::Api.check_chargen_locked(enactor)
      end
      
      def parse_args
        self.age = trim_arg(cmd.args)
      end
      
      def handle
        bday = Date.new ICTime::Api.ictime.year - self.age.to_i, ICTime::Api.ictime.month, ICTime::Api.ictime.day
        bday = bday - rand(364)
        
        demographics = enactor.get_or_create_demographics
        
        demographics.update(birthdate: bday)

        client.emit_success t('demographics.birthdate_set', 
          :birthdate => ICTime::Api.ic_datestr(bday), 
          :age => enactor.age)
      end
        
    end
    
  end
end