module AresMUSH
  module Website
    class SaveConfigRequestHandler
      def handle(request)
        file = request.args[:file]
        config = request.args[:config]
        enactor = request.enactor
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!enactor.is_admin?)
          return { error: "You are not an admin." }
        end
        
        path = File.join(AresMUSH.game_path, "config", file)
        
        if (!File.exists?(path))
          return { error: "Config file not found." }
        end
                
        begin
          section = file.before('.yml').before('_')
          yaml_hash = {}
          yaml_hash[section] = {}
          config.each do |k, v|
            yaml_hash[section][k] = YAML.load(v)
          end
          
          File.open(path, 'w') do |f|
              f.write(yaml_hash.to_yaml)
          end
                    
        rescue Exception => ex
          return { error: "There was a problem loading your config YAML.  See http://aresmush.com/tutorials for troubleshooting help: #{ex}" }
          Global.logger.warn "Trouble loading YAML config; #{ex}"
        end
        
        {}
        
      end
    end
  end
end