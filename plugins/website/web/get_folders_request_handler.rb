module AresMUSH
  module Website
    class GetFoldersRequestHandler
      def handle(request)
        enactor = request.enactor
        folder = request.args['folder']
        
        error = Website.check_login(request, true)
        return error if error
        
        folders = Dir[File.join(AresMUSH.website_uploads_path, "*")]
        
        
        folders.select { |f| Dir[File.join(f, "*")].count > 0 }
          .sort
          .map { |f| {
             name: f.gsub(AresMUSH.website_uploads_path, '').gsub('/', '')
          } }
      end
    end
  end
end