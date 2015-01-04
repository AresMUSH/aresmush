module AresMUSH
  module PluginRequiresLogin
    # Make sure this runs before other validators - hence the '1' in the name.
    def check_1_for_login
      return t('dispatcher.must_be_logged_in') if !client.logged_in?
      return nil
    end
  end
    
  module PluginWithoutArgs
    # Make sure this runs before other validators except login - hence the '2' in the name.
    def check_2_no_args
      return t('dispatcher.cmd_no_args') if !cmd.args.nil?
      return nil
    end
  end
    
  module PluginWithoutSwitches
    # Make sure this runs before other validators except login - hence the '2' in the name.
    def check_2_no_switches
      return t('dispatcher.cmd_no_switches') if !cmd.switch.nil?
      return nil
    end
  end
    
  module PluginRequiresArgs
    attr_accessor :required_args
    attr_accessor :help_topic

    # Make sure this runs before other validators except login - hence the '2' in the name.
    def check_2_arguments_present
      if (self.required_args.nil?)
        raise "Plugin #{self.class} says it requires args but has none listed"
      end
      
      self.required_args.each do |arg|
        return t('dispatcher.invalid_syntax', :command => self.help_topic) if "#{self.send("#{arg}")}".strip.length == 0
      end
      return nil
    end
  end
end