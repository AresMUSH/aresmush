module AresMUSH
  module Website
    class GetConfigRequestHandler
      def handle(request)
        file = request.args[:file]
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        if (!Manage.can_manage_game?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
      
        path = File.join(AresMUSH.game_path, 'config', file)
        if (!File.exist?(path))
          return { error: t('webportal.not_found') }
        end
        
        begin
          section = file.before('.yml').before("_")
          config = {}
          yaml = YAML::load( File.read(path) )
          yaml[section].sort.each do |k, v|
            lines = [v.to_yaml.split(/[\n\r]/).count + 1, 25].min
            config[k] = { key: k, value: v, new_value: v, lines: lines }
          end
          
          help_link = (Global.read_config('plugins', 'config_help_links') || {})[section]
          help_link = help_link || "https://aresmush.com/tutorials/config/#{section}.html"
        
          { file: file, config:  config, valid: true, help: help_link }
        rescue Exception => ex
          { file: file, valid: false, help: help_link }
        end
      end
    end
  end
end