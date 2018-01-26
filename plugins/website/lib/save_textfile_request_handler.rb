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
          return { error: "You are not an admin." }
        end
        
        case file_type
        when "text"
          path = File.join(AresMUSH.game_path, 'text', file)
        when "style"
          path = File.join(AresMUSH.website_styles_path, file)
        end
        
        pp path
        
        if (!File.exists?(path))
          return { error: "Config file not found." }
        end
        
        File.open(path, 'w') do |f|
            f.write(text)
          end
        {}
        
      end
    end
  end
end