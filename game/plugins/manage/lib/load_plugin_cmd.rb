module AresMUSH
  module Manage
    class LoadPluginCmd
      include AresMUSH::Plugin

      # Validators
      must_be_logged_in
      
      attr_accessor :load_target
      
      def crack!
        self.load_target = cmd.args
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("load") && cmd.args != "locale" && cmd.args != "config"
      end

      # TODO - validate permissions
      
      def validate_load_target
        return t('manage.invalid_load_syntax') if load_target.nil?
        return nil
      end
      
      def handle
        begin
          AresMUSH.send(:remove_const, load_target.titlecase)
          Global.plugin_manager.load_plugin(load_target)
          Global.locale.load!
          Global.config_reader.read
          client.emit_success t('manage.plugin_loaded', :name => load_target)
        rescue SystemNotFoundException => e
          client.emit_failure t('manage.plugin_not_found', :name => load_target)
        rescue Exception => e
          client.emit_failure t('manage.error_loading_plugin', :name => load_target, :error => e.to_s)
        end
      end
    end
  end
end
