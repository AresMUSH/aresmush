require 'open-uri'

module AresMUSH
  module Website
    
    class FileDeleteRequestHandler
      def handle(request)
        enactor = request.enactor
        name = request.args[:name]
        folder = request.args[:folder]
        
        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        if (!Website.can_edit_wiki_file?(enactor, folder))
          return { error: t('dispatcher.not_allowed') }
        end
        
        path = File.join(AresMUSH.website_uploads_path, folder, name)
        
        if (!File.exists?(path))
          return { error: t('webportal.not_found') }
        end
        
        Website.add_to_recent_changes('file', t('webportal.file_deleted', :name => "#{folder}/#{name}"), { name: name, folder: folder }, enactor.name)
        
        File.delete(path)
        
        {
        }
      end
    end
  end
end