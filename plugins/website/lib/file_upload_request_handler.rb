module AresMUSH
  module Website
    
    class FileUploadRequestHandler
      def handle(request)
        enactor = request.enactor
        name = request.args[:name]
        allow_overwrite = request.args[:allow_overwrite] ? request.args[:allow_overwrite] : false
        folder = request.args[:folder] || ""
        size_kb = (request.args[:size_kb] || "").to_i
        data = request.args[:data]
        
        if (enactor)
          error = WebHelpers.check_login(request)
          return error if error
        end
        
        if (!enactor.is_approved?)
          return { error: "You are not allowed to upload files until you're approved." }
        end
      
        if (name.blank?)
          return { error: "Missing file or filename." }
          redirect redirect_url
        end
        
        max_upload_kb = Global.read_config("website", "max_upload_size_kb")
        if (size_kb > max_upload_kb)
          return { error: "Max file size is #{max_upload_kb}."}
        end
        
        name = AresMUSH::Website::FilenameSanitizer.sanitize name
        folder = AresMUSH::Website::FilenameSanitizer.sanitize folder
        folder_path = File.join(AresMUSH.website_uploads_path, folder)
        
        if (!Dir.exist?(folder_path))
          Dir.mkdir(folder_path)
        end
        
        path = File.join(folder_path, name)
        
        if (File.exists?(path) && !allow_overwrite)
          return { error: "That file already exists." }
        end
        
        
        File.open(path, 'wb') {|f| f.write Base64.decode64(data.after(',')) }
        
        {
          name: name
        }
      end
    end
  end
end