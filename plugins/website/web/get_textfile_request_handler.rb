module AresMUSH
  module Website
    class GetTextFileRequestHandler
      def handle(request)
        file = request.args[:file]
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
        when "config"
          path = File.join(AresMUSH.game_path, 'config', file)
        when "style"
          path = File.join(AresMUSH.website_styles_path, file)
        end
        
        if (!File.exists?(path))
          return { error: "Config file does not exist."}
        end
        
        text = File.read(path)
        
          { file: file, text: WebHelpers.format_input_for_html(text), file_type: file_type }

      end
    end
  end
end