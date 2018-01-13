require 'open-uri'

module AresMUSH
  module Website
    
    class FileDeleteRequestHandler
      def handle(request)
        enactor = request.enactor
        path = request.args[:path]

        error = WebHelpers.validate_auth_token(request)
        return error if error
        
        if (!enactor.is_admin?)
          return { error: "Only admins can delete files." }
        end
        
        path = File.join(AresMUSH.website_uploads_path, path)
        
        if (!File.exists?(path))
          return { error: "That file does not exist." }
        end
        
        File.delete(path)
        
        {
        }
      end
    end
  end
end