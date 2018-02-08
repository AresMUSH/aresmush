module AresMUSH
  module Website
    class GetConfigRequestHandler
      def handle(request)
        file = request.args[:file]
        enactor = request.enactor
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!enactor.is_admin?)
          return { error: "You are not an admin." }
        end
      
        path = File.join(AresMUSH.game_path, 'config', file)
        if (!File.exists?(path))
          return { error: "Config file does not exist."}
        end
        
        begin
          section = file.before('.yml').before("_")
          config = {}
          yaml = YAML::load( File.read(path) )
          yaml[section].sort.each do |k, v|
            lines = [v.to_yaml.split(/[\n\r]/).count + 1, 25].min
            config[k] = { key: k, value: v, new_value: v, lines: lines }
          end
        
          { file: file, config:  config }
        rescue Exception => ex
          return { error: "There was a problem loading your config YAML for #{file}.  See http://aresmush.com/tutorials for troubleshooting help: #{ex}" }
          Global.logger.warn "Trouble loading YAML config; #{ex}"
        end
        
      end
    end
  end
end