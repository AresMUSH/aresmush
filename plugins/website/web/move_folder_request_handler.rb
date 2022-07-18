require 'open-uri'

module AresMUSH
  module Website
    
    class MoveFolderRequestHandler
      def handle(request)
        enactor = request.enactor
        folder = request.args[:folder]
        new_folder = (request.args[:new_folder] || "").downcase
        files = request.args[:files] || []

        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        if (!Website.can_edit_wiki_file?(enactor, folder))
          return { error: t('dispatcher.not_allowed') }
        end
        
        new_folder = AresMUSH::Website::FilenameSanitizer.sanitize new_folder
        
        folder_path = File.join(AresMUSH.website_uploads_path, folder)
        new_folder_path = File.join(AresMUSH.website_uploads_path, new_folder)
        
        if (!File.exists?(folder_path))
          return { error: t('webportal.not_found') }
        end
        
        if (new_folder.blank? || files.empty?)
          return { error: t('webportal.missing_required_fields') }
        end
        
        if (folder == "theme_images" && !enactor.is_admin?)
          return { error: t('webportal.theme_locked_to_admin') }
        end
        
        if (new_folder_path == folder_path)
          return { error: t('webportal.file_already_exists') }
        end
        
        if (!Dir.exist?(new_folder_path))
          Dir.mkdir(new_folder_path)
        end
        
        files.each do |file|
          file_path = File.join(folder_path, file)
          FileUtils.mv(file_path, new_folder_path)
          Website.add_to_recent_changes('file', t('webportal.file_moved', :name => "#{folder}/#{file}"), { name: file, folder: new_folder }, enactor.name)
          file_meta = WikiFileMeta.find_meta(folder, file)
          if (file_meta)
            file_meta.update(folder: new_folder)
          end
        end
        
        
        {
          folder: new_folder
        }
      end
    end
  end
end