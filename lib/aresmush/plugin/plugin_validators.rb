module AresMUSH
  module PluginRequiresLogin
    def check_for_login
      return t('dispatcher.must_be_logged_in') if !client.logged_in?
      return nil
    end
  end
    
  module PluginWithoutArgs
    def check_no_args
      return t('dispatcher.cmd_no_switches_or_args') if !cmd.args.nil?
      return nil
    end
  end
    
  module PluginWithoutSwitches
    def check_no_switches
      return t('dispatcher.cmd_no_switches') if !cmd.switch.nil?
      return nil
    end
  end
    
  module PluginRequiresArgs
    attr_accessor :required_args
    attr_accessor :help_topic
    def check_arguments_present
      self.required_args.each do |arg|
        return t('dispatcher.invalid_syntax', :command => self.help_topic) if self.send("#{arg}").to_s.strip.length == 0
      end
      return nil
    end
  end
end