module AresMUSH
  module Website
    class GetFileRequestHandler
      def handle(request)
        enactor = request.enactor
        name = request.args[:name]
        folder = request.args[:folder]
        edit_mode = (request.args[:edit_mode] || "").to_bool
        
        error = Website.check_login(request, true)
        return error if error
      
        if (name.blank? || folder.blank?)
          return { error: t('webportal.missing_required_fields', :fields => "name, folder") }
        end
        
        path = File.join(folder, name)
        
        if (!File.exists?( File.join(AresMUSH.website_uploads_path, path)))
          return { error: t('webportal.not_found') }
        end
        
        file_meta = WikiFileMeta.find_meta(folder, name)
        if (file_meta && file_meta.uploaded_by)
          uploaded_by = {
              name: file_meta.author_name,
              icon: Website.icon_for_char(uploaded_by)
            }
        else
          uploaded_by = nil
        end
               
        if (edit_mode)
          description = file_meta ? Website.format_input_for_html(file_meta.description) : ''
        else
          description = file_meta ? Website.format_markdown_for_html(file_meta.description) : ''
        end
                 
        {
          name: name,
          folder: folder,
          description: description,
          uploaded_by: uploaded_by,
          path: path,
          can_edit: Website.can_edit_wiki_file?(enactor, folder)
        }
      end
    end
  end
end