module AresMUSH
  module Demographics

    class BirthdateCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :date_str

      def initialize
        self.required_args = ['date_str']
        self.help_topic = 'demographics'
        super
      end
            
      def want_command?(client, cmd)
        cmd.root_is?("birthdate") 
      end

      def crack!
        self.date_str = cmd.args
      end
            
      def check_approval
        return t('demographics.cant_be_changed') if client.char.is_approved?
        return nil
      end
      
      def handle
        begin
          bday = Date.strptime(self.date_str, Global.config['server']['short_date_format'])
        rescue
          client.emit_failure t('demographics.invalid_birthdate', 
            :format_str => Global.config['server']['date_entry_format_help'])
          return
        end
        
        age = Demographics.calculate_age(bday)
        age_error = Demographics.check_age(age)
        
        if (!age_error.nil?)
          client.emit_failure age_error
          return
        end
        
        client.char.birthdate = bday
        client.char.save
        client.emit_success t('demographics.birthdate_set', 
          :birthdate => ICTime.ic_month_str(bday), 
          :age => client.char.age)
      end
        
    end
    
  end
end