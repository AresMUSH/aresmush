module AresMUSH
  module Plugin
    def self.included(base)
      base.send :extend, PluginValidators
    end

    module PluginValidators
      def must_be_logged_in
        send :define_method, "check_for_login" do
          return t('dispatcher.must_be_logged_in') if !client.logged_in?
          return nil
        end
      end
      
      def no_args
        send :define_method, "check_no_args" do
          return t('dispatcher.cmd_no_switches_or_args') if !cmd.args.nil?
          return nil
        end
      end

      def no_switches
        send :define_method, "check_no_switches" do
          return t('dispatcher.cmd_no_switches') if !cmd.switch.nil?
          return nil
        end
      end
      
      def argument_must_be_present(name, command_name)
        send :define_method, "check_#{name}_argument_present" do
          return t('dispatcher.invalid_syntax', :command => command_name) if self.send("#{name}").to_s.strip.length == 0
          return nil
        end
      end
      
      def must_have_role(roles)
        send :define_method, "check_has_role" do
          return t('dispatcher.permission_denied', :roles => [roles].join(",") ) if !client.char.has_any_role?(roles)
          return nil
        end
      end
    end
  end
end