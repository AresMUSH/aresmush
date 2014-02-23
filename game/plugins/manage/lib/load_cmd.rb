module AresMUSH
  module Manage
    class LoadCmd
      include AresMUSH::Plugin

      # Validators
      must_be_logged_in
      
      attr_accessor :load_target
      
      def after_initialize
        @plugin_manager = Global.plugin_manager
        @config_reader = Global.config_reader
      end
      
      def crack!
        self.load_target = cmd.args
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("load")
      end

      # TODO - validate permissions
      
      def validate_load_target
        return t('manage.invalid_load_syntax') if load_target.nil?
        return nil
      end
      
      def handle
        if (load_target == 'config')
          load_config
        elsif (load_target == 'locale')
          load_locale
        else
          load_plugin
        end
      end      
      
      def load_plugin
        begin
          AresMUSH.send(:remove_const, load_target.titlecase)
          @plugin_manager.load_plugin(load_target)
          client.emit_success t('manage.plugin_loaded', :name => load_target)
        rescue SystemNotFoundException => e
          client.emit_failure t('manage.plugin_not_found', :name => load_target)
        rescue Exception => e
          client.emit_failure t('manage.error_loading_plugin', :name => load_target, :error => e.to_s)
        end
        load_locale
      end
      
      def load_locale
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
