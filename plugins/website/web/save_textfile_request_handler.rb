module AresMUSH
  module Website
    class SaveTextFileRequestHandler
      def handle(request)
        file = request.args[:file]
        text = request.args[:text]
        file_type = request.args[:file_type]
        enactor = request.enactor
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!enactor.is_admin?)
          return { error: t('dispatcher.not_allowed') }
        end
        
        case file_type
        when "text"
          path = File.join(AresMUSH.game_path, 'text', file)
        when "style"
          path = File.join(AresMUSH.website_styles_path, file)
        end
                
        if (!File.exists?(path))
          return { error: t('webportal.not_found') }
        end
        
        File.open(path, 'w') do |f|
          f.write(text)
        end
        
        if (file_type == "style")
          WebHelpers.rebuild_css
        end
        {}
        
      end
    end
  end
end