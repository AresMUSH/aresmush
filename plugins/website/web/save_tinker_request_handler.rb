module AresMUSH
  module Website
    class SaveTinkerRequestHandler
      def handle(request)
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        if (!enactor.is_coder?)
          return { error: t('dispatcher.not_allowed') }
        end
        
        path = File.join(AresMUSH.plugin_path, 'tinker', 'commands', 'tinker_cmd.rb')
        begin
      
          File.open(path, 'w') do |f|
            f.write request.args['text']
          end
          begin
            Global.plugin_manager.unload_plugin("tinker")
          rescue SystemNotFoundException
            # Swallow this error.  Just means you're loading a plugin for the very first time.
          end
          # Make sure everything is valid before we start.
          Global.config_reader.validate_game_config          
          Global.plugin_manager.load_plugin("tinker")
          Global.config_reader.load_game_config   
                  
        
        rescue Exception => ex
          return { error: t('webportal.tinker_error', :error => ex ) }
        end
        
        {}
      
      end
    end
  end
end