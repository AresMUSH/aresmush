module AresMUSH
  module Website
    class SaveGameRequestHandler
      def handle(request)
        enactor = request.enactor
        config = request.args[:config]
        
        error = Website.check_login(request)
        return error if error
        
        if (!Manage.can_manage_game?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
       
        
        path = File.join(AresMUSH.game_path, 'config', 'game.yml')
        yaml_hash = { 
          'game' => config
        }
        
        yaml_hash['game']['public_game'] = config['public_game'].to_bool
        
        File.open(path, 'w') do |f|
          f.write(yaml_hash.to_yaml)
        end

        error = Manage.reload_config  
        if (error)
          Global.logger.warn "Trouble loading YAML config: #{error}"
          return { :warnings => Website.format_markdown_for_html(error) }
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