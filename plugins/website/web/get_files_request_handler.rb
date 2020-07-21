module AresMUSH
  module Website
    class GetFilesRequestHandler
      def handle(request)
        enactor = request.enactor
        folder = request.args['folder']
        
        error = Website.check_login(request, true)
        return error if error
        
        files = Dir[File.join(AresMUSH.website_uploads_path, folder, "**")]
                
        {
          folder: folder.gsub(AresMUSH.website_uploads_path, '').gsub('/', ''),
          files: files.select { |f| !File.directory?(f) }.sort.map { |f| 
            {
             name: File.basename(f),
             size: File.size(f) / 1024,
             folder: folder.gsub(AresMUSH.website_uploads_path, '').gsub('/', ''),
             path: f.gsub(AresMUSH.website_uploads_path, '')
            }
          }
        }
      end
    end
  end
end