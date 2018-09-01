module AresMUSH
  module Website
    
    class FileUploadRequestHandler
      def handle(request)
        enactor = request.enactor
        name = (request.args[:name] || "").downcase
        allow_overwrite = request.args[:allow_overwrite] ? request.args[:allow_overwrite] : false
        folder = request.args[:folder] || ""
        size_kb = (request.args[:size_kb] || "").to_i
        data = request.args[:data]
        
        error = Website.check_login(request)
        return error if error
        
        if (!enactor.is_approved?)
          return { error: t('dispatcher.not_allowed') }
        end
      
        if (name.blank? || folder.blank?)
          return { error: t('webportal.missing_required_fields') }
        end
        
        if (folder && folder.downcase == "theme_images" && !enactor.is_admin?)
          return { error: t('webportal.theme_locked_to_admin') }
        end
        
        max_upload_kb = Global.read_config("website", "max_upload_size_kb")
        if (size_kb > max_upload_kb)
          return { error: t('webportal.max_upload_size', :kb => max_upload_kb) }
        end
        
        name = AresMUSH::Website::FilenameSanitizer.sanitize name
        folder = AresMUSH::Website::FilenameSanitizer.sanitize folder
        folder_path = File.join(AresMUSH.website_uploads_path, folder)
        
        if (!Dir.exist?(folder_path))
          Dir.mkdir(folder_path)
        end
        
        path = File.join(folder_path, name)
        
        if (File.exists?(path) && !allow_overwrite)
          return { error: t('webportal.file_already_exists')  }
        end
        
        
        File.open(path, 'wb') {|f| f.write Base64.decode64(data.after(',')) }
        
        {
          name: name
        }
      end
    end
  end
end