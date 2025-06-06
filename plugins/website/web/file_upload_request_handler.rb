module AresMUSH
  module Website
    
    class FileUploadRequestHandler
      def handle(request)
        enactor = request.enactor
        name = (request.args['name'] || "").downcase
        description = request.args['description']
        allow_overwrite = (request.args['allow_overwrite'] || "").to_bool
        folder = (request.args['folder'] || "").downcase
        size_kb = (request.args['size_kb'] || "").to_i
        data = request.args['data']
        
        error = Website.check_login(request)
        return error if error
        
        Global.logger.info "#{enactor.name} uploading file #{name}."
        
        if (name.blank? || folder.blank?)
          return { error: t('webportal.missing_required_fields', :fields => "name, folder") }
        end
        
        is_wiki_admin = Website.can_manage_wiki?(enactor)
        is_theme_admin = Website.can_manage_theme?(enactor)
        extension = File.extname(name) || ""

        allowed_extensions = (Global.read_config("website", "uploadable_extensions") || []).map { |e| e.downcase }
        if (allowed_extensions.any?)
          if (!is_wiki_admin && !allowed_extensions.include?(extension.downcase))
            return { error: t('webportal.only_upload_images', extensions: allowed_extensions.join(", ")) }
          end
        end
        
        # Unapproved chars can only update their own profile image.
        if (!enactor.is_approved?)
          name = "profile#{extension}"
          folder = "#{enactor.name.downcase}"
          allow_overwrite = true
        end
        
        if (folder && folder.downcase == "theme_images" && !is_theme_admin)
          return { error: t('webportal.theme_locked_to_admin') }
        end
        
        max_upload_kb = Global.read_config("website", "max_upload_size_kb")
        if (size_kb > max_upload_kb && !is_wiki_admin)
          return { error: t('webportal.max_upload_kb', :kb => max_upload_kb) }
        end
        
        name = FilenameSanitizer.sanitize name
        folder = FilenameSanitizer.sanitize folder
        folder_path = File.join(AresMUSH.website_uploads_path, folder)
        
        if (!Dir.exist?(folder_path))
          Dir.mkdir(folder_path)
        end
        
        folder_size_kb = Website.folder_size_kb(folder_path)
        max_folder_kb = Global.read_config("website", "max_folder_size_kb")
        if (folder_size_kb + size_kb > max_folder_kb && !is_wiki_admin)
          return { error: t('webportal.max_folder_size_kb', :kb => max_folder_kb) }
        end
        
        
        path = File.join(folder_path, name)
        
        if (File.exist?(path) && !allow_overwrite)
          return { error: t('webportal.file_already_exists')  }
        end
        
        file_meta = WikiFileMeta.find_meta(folder, name)
        if (file_meta)
          file_meta.update(uploaded_by: enactor, description: description)
        else
          WikiFileMeta.create(name: name, folder: folder, description: description, uploaded_by: enactor)
        end
        
        File.open(path, 'wb') {|f| f.write Base64.decode64(data.after(',')) }
        
        Website.add_to_recent_changes('file', t('webportal.file_uploaded', :name => "#{folder}/#{name}"), { name: name, folder: folder }, enactor.name)
        
        {
          name: name,
          folder: folder
        }
      end
    end
  end
end