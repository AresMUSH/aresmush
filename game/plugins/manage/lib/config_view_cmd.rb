module AresMUSH
  module Manage
    class ConfigViewCmd
      include AresMUSH::Plugin

      attr_accessor :section
      
      # Validators
      must_be_logged_in
      
      def want_command?(client, cmd)
        cmd.root_is?("config") && cmd.switch.nil? && !cmd.args.nil?
      end

      def crack!
        self.section = cmd.args
      end
      
      def validate_section_exists
        return t('manage.invalid_config_section') if !Global.config.has_key?(self.section)
        return nil
      end
      
      # TODO - validate permissions
      
      def handle
        output = "%l1"
        output << "%r%xh#{t('manage.config_section', :name => self.section)}%xn"
        output << "%r"
        output << PP.pp(Global.config[self.section], "")
        output << "%R%l1"
        client.emit output
      end
    end
  end
end