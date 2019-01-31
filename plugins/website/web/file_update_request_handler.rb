require 'open-uri'

module AresMUSH
  module Website
    
    class FileUpdateRequestHandler
      def handle(request)
        enactor = request.enactor
        name = request.args[:name]
        folder = request.args[:folder]
        new_name = (request.args[:new_name] || "").downcase
        new_folder = (request.args[:new_folder] || "").downcase

        error = Website.check_login(request)
        return error if error
        
        if (!Website.can_edit_wiki_file?(enactor, folder))
          return { error: t('dispatcher.not_allowed') }
        end
        
        new_name = AresMUSH::Website::FilenameSanitizer.sanitize new_name
        new_folder = AresMUSH::Website::FilenameSanitizer.sanitize new_folder
        
        path = File.join(AresMUSH.website_uploads_path, folder, name)
        new_folder_path = File.join(AresMUSH.website_uploads_path, new_folder)
        new_path = File.join(new_folder_path, new_name)
        
        if (!File.exists?(path))
          return { error: t('webportal.not_found') }
        end
        
        if (new_name.blank? || new_folder.blank?)
          return { error: t('webportal.missing_required_fields') }
        end
        
        if (File.exists?(new_path))
          return { error: t('webportal.file_already_exists')  }
        end
        
        if (folder == "theme_images" && !enactor.is_admin?)
          return { error: t('webportal.theme_locked_to_admin') }
        end
        
        if (!Dir.exist?(new_folder_path))
          Dir.mkdir(new_folder_path)
        end
        
        FileUtils.mv(path, new_path)
        
        {
          path: new_path.gsub(AresMUSH.website_uploads_path, ''),
          folder: new_folder,
          name: new_name
        }
      end
    end
  end
end