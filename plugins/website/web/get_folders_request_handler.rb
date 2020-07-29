module AresMUSH
  module Website
    class GetFoldersRequestHandler
      def handle(request)
        enactor = request.enactor
        folder = request.args['folder']
        
        error = Website.check_login(request, true)
        return error if error
        
        folders = Dir[File.join(AresMUSH.website_uploads_path, "*")]
        
        
        folders.sort.map { |f| {
          name: f.gsub(AresMUSH.website_uploads_path, '').gsub('/', '')
          } }
      end
    end
  end
end