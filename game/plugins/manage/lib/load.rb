module AresMUSH
  module Manage
    class Load
      include AresMUSH::Plugin

      def after_initialize
        @plugin_manager = Global.plugin_manager
      end

      def want_command?(cmd)
        cmd.logged_in? && cmd.root_is?("load")
      end

      def validate
        # TODO - validate permissions
        return t('manage.invalid_load_syntax') if !cmd.switch.nil?
        return t('manage.invalid_load_syntax') if cmd.args.nil?
        return nil
      end
      
      def handle
        name = cmd.args
        if (load_name == 'config')
          load_config
        else
          load_plugin(name)
        end
      end
      
      def load_plugin(plugin_name)        
        begin
          AresMUSH.send(:remove_const, plugin_name.titlecase)
          @plugin_manager.load_plugin(plugin_name)
          client.emit_success t('manage.plugin_loaded', :name => plugin_name)
        rescue SystemNotFoundException => e
          client.emit_failure t('manage.plugin_not_found', :name => plugin_name)
        rescue Exception => e
          client.emit_failure t('manage.error_loading_plugin', :name => plugin_name, :error => e.to_s)
        end
        Global.locale.load!
      end
      
      def load_config
        begin
          @config_reader.read
          client.emit_success t('manage.config_loaded')
        rescue Exception => e
          client.emit_failure t('manage.error_loading_config', :error => e.to_s)
        end
      end
      
    end
  end
end
