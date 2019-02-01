module AresMUSH
  module Website
    class GetFileRequestHandler
      def handle(request)
        enactor = request.enactor
        name = request.args[:name]
        folder = request.args[:folder]
        
        error = Website.check_login(request, true)
        return error if error
      
        if (name.blank? || folder.blank?)
          return { error: t('webportal.missing_required_fields') }
        end
        
        path = File.join(folder, name)
        
        {
          name: name,
          folder: folder,
          path: path,
          can_edit: Website.can_edit_wiki_file?(enactor, folder)
        }
      end
    end
  end
end