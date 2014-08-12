module AresMUSH
  module Demographics

    class AgeCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :age

      def initialize
        self.required_args = ['age']
        self.help_topic = 'demographics'
        super
      end
            
      def want_command?(client, cmd)
        cmd.root_is?("age") 
      end

      def check_age        
        return t('demographics.invalid_age') if !self.age.is_integer?
        return Demographics.check_age(self.age.to_i)
      end
      
      def check_approval
        return t('demographics.cant_be_changed') if client.char.is_approved?
        return nil
      end
      
      def crack!
        self.age = trim_input(cmd.args)
      end
      
      def handle
        bday = Date.new ICTime.ictime.year - self.age.to_i, ICTime.ictime.month, ICTime.ictime.day
        bday = bday - rand(364)
        client.char.birthdate = bday
        client.char.save
        client.emit_success t('demographics.birthdate_set', :birthdate => bday, :age => client.char.age)
      end
        
    end
    
  end
end