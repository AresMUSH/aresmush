module AresMUSH
  module Demographics

    class AgeCmd
      include CommandHandler
      
      attr_accessor :age
      
      def required_args
        [ self.age ]
      end
         
      def check_chargen_locked
        return nil if Chargen.can_manage_apps?(enactor)    
        enabled_after_cg = Global.read_config("demographics", "editable_properties")
        return nil if enabled_after_cg.include?('birthdate')
        Chargen.check_chargen_locked(enactor)
      end
      
      def parse_args
        self.age = integer_arg(cmd.args)
      end
      
      def handle
        error = Demographics.check_age(self.age)
        if (error)
          client.emit_failure error
          return
        end
        
        bday = Demographics.set_random_birthdate(enactor, self.age)
        
        client.emit_success t('demographics.birthdate_set', 
          :birthdate => ICTime.ic_datestr(bday), 
          :age => enactor.age)
      end
        
    end
    
  end
end