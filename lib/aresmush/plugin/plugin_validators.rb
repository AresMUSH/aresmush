module AresMUSH
  module CommandRequiresLogin
    # Make sure this runs before other validators - hence the '1' in the name.
    def check_1_for_login
      return t('dispatcher.must_be_logged_in') if !client.logged_in?
      return nil
    end
  end
    
  module CommandWithoutArgs
    # Make sure this runs before other validators except login - hence the '2' in the name.
    def check_2_no_args
      return t('dispatcher.cmd_no_args') if cmd.args
      return nil
    end
  end
    
  module CommandWithoutSwitches
    # Make sure this runs before other validators except login - hence the '2' in the name.
    def check_2_no_switches
      return t('dispatcher.cmd_no_switches') if cmd.switch
      return nil
    end
  end
  
  module CommandRequiresArgs
    def required_args
      raise "Plugin #{self.class} says it requires args but has none listed"
    end
    
    # Make sure this runs before other validators except login - hence the '2' in the name.
    def check_2_arguments_present
     
      required_args[:args].each do |arg|
        return t('dispatcher.invalid_syntax', :command => required_args[:help]) if "#{arg}".strip.length == 0
      end
      return nil
    end
  end
end