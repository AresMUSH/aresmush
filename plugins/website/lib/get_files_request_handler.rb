module AresMUSH
  module Website
    class GetFilesRequestHandler
      def handle(request)
        enactor = request.enactor
        
        if (enactor)
          error = WebHelpers.validate_auth_token(request)
          return error if error
        end
        
        dirs = Dir[File.join(AresMUSH.website_uploads_path, "**/**")].group_by { |f| File.dirname(f) }         
                
        dirs.sort.map { |dir, files| {
          name: dir.gsub(AresMUSH.website_uploads_path, '').gsub('/', ''),
          files: files.select { |f| !File.directory?(f) }.sort.map { |f| 
            {
             name: File.basename(f),
             size: File.size(f)/ 1024,
             path: f.gsub(AresMUSH.website_uploads_path, '')
            }
          }
        }}
      end
    end
  end
end