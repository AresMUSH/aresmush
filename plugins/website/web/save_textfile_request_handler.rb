module AresMUSH
  module Website
    class SaveTextFileRequestHandler
      def handle(request)
        file = request.args['file']
        text = request.args['text']
        file_type = request.args['file_type']
        enactor = request.enactor
        
        error = Website.check_login(request)
        return error if error
        
        Global.logger.info "#{enactor.name} updating text file #{file}."
        
        if (!Website.can_manage_textfile?(enactor, file_type))
          return { error: t('dispatcher.not_allowed') }
        end
        
        case file_type
        when "text"
          path = File.join(AresMUSH.game_path, 'text', file)
        when "style"
          path = File.join(AresMUSH.website_styles_path, file)
        when "config"
          path = File.join(AresMUSH.game_path, 'config', file)
        when "code"
          path = Website.find_code_file_path(file)
        end
                
        if (!File.exist?(path))
          return { error: t('webportal.not_found') }
        end
        
        if (file_type == "config")
          begin
              yaml_hash = YAML.load(text)
          rescue Exception => ex
            Global.logger.warn "Trouble loading YAML config: #{ex}"
            return { error: t('webportal.config_error', :error => ex, :file => file ) }
          end
        end
        
        File.open(path, 'w') do |f|
          f.write(text)
        end
        
        begin
          if (file_type == "style")
            error = Website.rebuild_css
            if (error)
              return { :warnings => error }
            end
          else
            error = Manage.reload_config     
            if (error)
              Global.logger.warn "Trouble loading YAML config: #{error}"
              return { :warnings => Website.format_markdown_for_html(error) }
            end
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