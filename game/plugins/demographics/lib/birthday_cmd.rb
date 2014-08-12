module AresMUSH
  module Demographics

    class BirthdateCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :month, :day, :year

      def initialize
        self.required_args = ['month', 'day', 'year']
        self.help_topic = 'demographics'
        super
      end
            
      def want_command?(client, cmd)
        cmd.root_is?("birthdate") 
      end

      def crack!
        cmd.crack!(/^(?<year>[\d]{4})\-(?<month>[\d]{2})\-(?<day>[\d]{2})$/)
        self.month = cmd.args.month
        self.day = cmd.args.day
        self.year = cmd.args.year
      end
      
      def check_dates
        return nil if self.month.nil?
        return t('demographics.invalid_birthdate') if !self.month.is_integer?
        return t('demographics.invalid_birthdate') if !self.day.is_integer?
        return t('demographics.invalid_birthdate') if !self.year.is_integer?
        return t('demographics.invalid_birthdate') if !Date.valid_date? self.year.to_i, self.month.to_i, self.day.to_i
        return nil
      end
      
      def handle
        bday = Date.new self.year.to_i, self.month.to_i, self.day.to_i
        age = Demographics.calculate_age(bday)
        age_error = Demographics.check_age(age)
        
        if (!age_error.nil?)
          client.emit_failure age_error
          return
        end
        
        client.char.birthdate = bday
        client.char.save
        client.emit_success t('demographics.birthdate_set', :birthdate => bday, :age => client.char.age)
      end
        
    end
    
  end
end