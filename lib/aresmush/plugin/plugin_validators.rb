module AresMUSH
  module Plugin
    def self.included(base)
      base.send :extend, PluginValidators
    end

    # This one is always on.
    
    def allowed_switches
      nil
    end
    
    def validate_allowed_switches
      return nil if cmd.switch.nil? || self.allowed_switches.nil?
      return t('dispatcher.cmd_no_switches') if self.allowed_switches.empty?
      return t('dispatcher.cmd_invalid_switch') if !self.allowed_switches.include?(cmd.switch)
      return nil
    end
    
    module PluginValidators
      def must_be_logged_in
        send :define_method, "validate_check_for_login" do
          return t('dispatcher.must_be_logged_in') if !client.logged_in?
          return nil
        end
      end
      
      def no_args
        send :define_method, "validate_no_args" do
          return t('dispatcher.cmd_no_switches_or_args') if !cmd.args.nil?
          return nil
        end
      end

      # Shortcut for allowing switches.
      def allow_switches(switches)
        send :define_method, "allowed_switches" do
          switches
        end
      end
            
      def allow_switch(switch)
        allow_switches([switch])
      end
      
      def no_switches
        allow_switches([])
      end
    end
    
  end
end