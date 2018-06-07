module AresMUSH
  module Website
    class SaveGameRequestHandler
      def handle(request)
        enactor = request.enactor
        config = request.args[:config]
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!enactor.is_admin?)
          return { error: t('dispatcher.not_allowed') }
        end
        
        path = File.join(AresMUSH.game_path, 'config', 'game.yml')
        yaml_hash = { 
          'game' => config
        }
        
        File.open(path, 'w') do |f|
            f.write(yaml_hash.to_yaml)
        end
        
        Manage.reload_config
        
        if (Game.master.api_key)
          AresCentral.update_game
        else
          AresCentral.register_game
        end
        {
        }
      end
    end
  end
end