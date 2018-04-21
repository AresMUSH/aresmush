module AresMUSH
  module Manage
    class LoadPluginCmd
      include CommandHandler
      
      attr_accessor :load_target
      
      def parse_args
        self.load_target = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.load_target ]
      end
      
      def check_plugin_name
        return t('manage.invalid_plugin_name') if self.load_target !~ /^[\w\-]+$/
        return nil
      end
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end
      
      def handle
        begin
          # Make sure everything is valid before we start.
          Global.config_reader.validate_game_config          
        rescue
          client.emit_failure t('manage.management_config_messed_up')
          return
        end
        
        client.emit_ooc t('manage.loading_plugin_please_wait', :name => load_target)
        begin
          begin
            Global.plugin_manager.unload_plugin(load_target)
          rescue SystemNotFoundException
            # Swallow this error.  Just means you're loading a plugin for the very first time.
          end
          Global.config_reader.load_game_config
          Global.plugin_manager.load_plugin(load_target)
          Help.reload_help
          Global.locale.reload
          Global.dispatcher.queue_event ConfigUpdatedEvent.new
          client.emit_success t('manage.plugin_loaded', :name => load_target)
        rescue SystemNotFoundException => e
          client.emit_failure t('manage.plugin_not_found', :name => load_target)
        rescue Exception => e
          Global.logger.debug "Error loading plugin: #{e}  backtrace=#{e.backtrace[0,10]}"
          client.emit_failure t('manage.error_loading_plugin', :name => load_target, :error => e)
        end
      end
    end
  end
end
