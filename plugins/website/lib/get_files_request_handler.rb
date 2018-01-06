module AresMUSH
  module Website
    class GetFilesRequestHandler
      def handle(request)
        enactor = request.enactor
        
        if (enactor)
          error = WebHelpers.validate_auth_token(request)
          return error if error
        end
        
        files =Dir[File.join(AresMUSH.website_uploads_path, "*")]
        
        files.sort.map { |f| {
          name: File.basename(f),
          size: File.size(f)/ 1024
          }
        }
        
      end
    end
  end
end