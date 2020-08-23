module AresMUSH
  module Website
    class GetFilesRequestHandler
      def handle(request)
        enactor = request.enactor
        folder = request.args['folder']
        
        error = Website.check_login(request, true)
        return error if error
        
        folder_path = File.join(AresMUSH.website_uploads_path, folder)
        files = Dir[File.join(folder_path, "**")]
                
        {
          folder: folder.gsub(AresMUSH.website_uploads_path, '').gsub('/', ''),
          folder_size: Website.folder_size_kb(folder_path),
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