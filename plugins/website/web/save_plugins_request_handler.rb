module AresMUSH
  module Website
    class SavePluginsRequestHandler
      def handle(request)
        enactor = request.enactor
        disabled_plugins = request.args[:disabled_plugins] || []
        
        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        if (!Manage.can_manage_game?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        new_config = Global.read_config("plugins")
        
        existing_plugins = new_config["disabled_plugins"]
        changed_plugins = (existing_plugins - disabled_plugins) | (disabled_plugins - existing_plugins)
        new_config["disabled_plugins"] = disabled_plugins
        
        path = File.join(AresMUSH.game_path, 'config', 'plugins.yml')
        yaml_hash = { 
          'plugins' => new_config
        }
        
        File.open(path, 'w') do |f|
          f.write(yaml_hash.to_yaml)
        end

        begin
          # Make sure everything is valid before we start.
          Global.config_reader.validate_game_config          
          Global.config_reader.load_game_config   
          error = nil
          changed_plugins.each do |p|
            begin
              Global.plugin_manager.unload_plugin(p)
            rescue SystemNotFoundException
              # Swallow this error.  Just means you're loading a plugin for the very first time.
            end
            Global.plugin_manager.load_plugin(p)
          end      
          Help.reload_help
          Global.locale.reload
          Global.dispatcher.queue_event ConfigUpdatedEvent.new
        rescue Exception => ex
          Global.logger.error ex
          error = ex.to_s
        end
              

        {
          error: error
        }
      end
    end
  end
end