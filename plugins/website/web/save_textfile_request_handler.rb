module AresMUSH
  module Website
    class SaveTextFileRequestHandler
      def handle(request)
        file = request.args[:file]
        text = request.args[:text]
        file_type = request.args[:file_type]
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        if (!Manage.can_manage_game?(enactor))
          return { error: t('dispatcher.not_allowed') }
        end
        
        case file_type
        when "text"
          path = File.join(AresMUSH.game_path, 'text', file)
        when "style"
          path = File.join(AresMUSH.website_styles_path, file)
        when "config"
          path = File.join(AresMUSH.game_path, 'config', file)
        end
                
        if (!File.exists?(path))
          return { error: t('webportal.not_found') }
        end
        
        if (file_type == "config")
          begin
              yaml_hash = YAML.load(text)
          rescue Exception => ex
            Global.logger.warn "Trouble loading YAML config; #{ex}"
            return { error: t('webportal.config_error', :error => ex, :file => file ) }
          end
        end
        
        File.open(path, 'w') do |f|
          f.write(text)
        end
        
        if (file_type == "style")
          Website.rebuild_css
        else
          Manage.reload_config
        end
        {}
        
      end
    end
  end
end