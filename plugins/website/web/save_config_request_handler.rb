module AresMUSH
  module Website
    class SaveConfigRequestHandler
      def handle(request)
        file = request.args[:file]
        config = request.args[:config]
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        Global.logger.info "#{enactor.name} updating config for #{file}."
        
        if (!Manage.can_manage_game?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        path = File.join(AresMUSH.game_path, "config", file)
        
        if (!File.exists?(path))
          return { error: t('webportal.not_found') }
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
          
          error = Manage.reload_config     
          if (error)
            Global.logger.warn "Trouble loading YAML config: #{error}"
            return { :warnings => Website.format_markdown_for_html(error) }
          end
                    
        rescue Exception => ex
          Global.logger.warn "Trouble loading YAML config: #{ex}"
          return { error: t('webportal.config_error', :error => ex, :file => file ) }
        end
        
        {}
        
      end
    end
  end
end