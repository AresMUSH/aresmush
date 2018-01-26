require 'open-uri'

module AresMUSH
  module Website
    
    class FileDeleteRequestHandler
      def handle(request)
        enactor = request.enactor
        name = request.args[:name]
        folder = request.args[:folder]
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (!enactor.is_admin?)
          return { error: "Only admins can delete files." }
        end
        
        path = File.join(AresMUSH.website_uploads_path, folder, name)
        
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