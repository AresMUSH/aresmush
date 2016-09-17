module AresMUSH
  module Manage
    class LoadPluginCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :load_target
      
      def initialize
        self.required_args = ['load_target']
        self.help_topic = 'load'
        super
      end
      
      def crack!
        self.load_target = trim_input(cmd.args)
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("load") && 
        cmd.args != "locale" && cmd.args != "config"
      end
      
      def check_plugin_name
        return t('manage.invalid_plugin_name') if self.load_target !~ /^[\w\-]+$/
        return nil
      end
      
      def handle
        begin
          can_manage = Manage.can_manage_game?(client.char)
          if (!can_manage)
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
        rescue
          client.emit_failure t('manage.management_config_messed_up')
        end
        
        client.emit_ooc t('manage.loading_plugin_please_wait', :name => load_target)
        begin
          begin
            
            Global.plugin_manager.unload_plugin(load_target)
          rescue SystemNotFoundException
            # Swallow this error.  Just means you're loading a plugin for the very first time.
          end
          Global.plugin_manager.load_plugin(load_target)
          Help::Interface.load_help
          Global.client_monitor.reload_clients
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
