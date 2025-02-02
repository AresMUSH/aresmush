module AresMUSH
  module Website
    class SaveGameRequestHandler
      def handle(request)
        enactor = request.enactor
        config = request.args['config']
                
        error = Website.check_login(request)
        return error if error
        
        Global.logger.info "#{enactor.name} updating game info."
        
        if (!Manage.can_manage_game?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
               
        config['public_game'] = config['public_game'].to_bool

        game_params = {}
        config.each do |k, v|
          game_params[k] = v
        end
        
        yaml_hash = { 
          'game' => game_params
        }
                
        DatabaseMigrator.write_config_file("game.yml", yaml_hash)

        error = Manage.reload_config  
        if (error)
          Global.logger.warn "Game registration not updated due to configuration errors: #{error}"
          return { warning: Website.format_markdown_for_html( t('webportal.game_directory_not_updated', :error => error) ) } 
        end
                  
        if (AresCentral.is_registered?)
          AresCentral.update_game
        elsif (AresCentral.is_public_game?)
          AresCentral.register_game
        end
         
        {
        }
      end
    end
  end
end