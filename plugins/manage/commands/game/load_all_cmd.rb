module AresMUSH
  module Manage
    class LoadAllCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage_game?(enactor)
        return nil
      end
      
      def handle
        begin
          # Make sure everything is valid before we start.
          Global.config_reader.validate_game_config          
        rescue
          client.emit_failure t('manage.game_config_invalid')
          return
        end
        
        client.emit_ooc t('manage.load_all')
        begin
          Global.plugin_manager.all_plugin_folders.each do |load_target|
            begin
              Global.plugin_manager.unload_plugin(load_target)
            rescue SystemNotFoundException
              # Swallow this error.  Just means you're loading a plugin for the very first time.
            end
          end
          Global.config_reader.load_game_config
          
          Global.plugin_manager.all_plugin_folders.each do |load_target|
            begin
              Global.plugin_manager.load_plugin(load_target)                      
            rescue SystemNotFoundException => e
              client.emit_failure t('manage.plugin_not_found', :name => load_target)
            rescue Exception => e
              Global.logger.debug "Error loading plugin: #{e}  backtrace=#{e.backtrace[0,10]}"
              client.emit_failure t('manage.error_loading_plugin', :name => load_target, :error => e)
            end
          end
          Help.reload_help
          Global.locale.reload
          Global.dispatcher.queue_event ConfigUpdatedEvent.new
        
        end
        client.emit_success t('manage.load_all_complete')
        
      end
      
      end
    end
  end
