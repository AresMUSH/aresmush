module AresMUSH
  class WebApp 
    helpers do
      def upload_path
        File.join(AresMUSH.game_path, 'plugins', 'website', 'web', 'public', 'files')
      end
      
      def file_size_kb(file)
        File.size(file)/ 1024
      end
      
      def uploaded_file_names
        uploaded_files.map { |f| File.basename(f) }.sort
      end
      
      def uploaded_files
        Dir[File.join(upload_path, "*")]
      end
    end
    
    get '/files/?' do
      @page = params[:page] ? params[:page].to_i : 1
      paginator = AresMUSH::Paginator.paginate uploaded_files, @page, 25
      @files = paginator.items
      @pages = paginator.total_pages
      
      erb :"files/files_index"
    end
    
    get '/files/upload/?', :auth => :approved  do
      @show_header = true
      @prefix = ""
      erb :"files/upload"
    end
    
    get '/files/upload-snippet/?', :auth => :approved  do
      @redirect_url = "/files/upload-snippet"
      @show_header = false
      @prefix = params[:prefix] + "_"
      erb :"files/upload", :layout => :"layout_embedded"
    end
    
    get '/file/rename/?', :auth => :approved do
      @file = params[:file]
      path = File.join(upload_path, @file)
      
      if (!File.exists?(path))
        flash[:error] = "File doesn't exist."
        redirect '/files'
      end
      
      erb :"files/rename"
    end
    
    post '/file/rename/?', :auth => :approved do
      file = params[:file]
      new_name = AresMUSH::Website::FilenameSanitizer.sanitize params[:name]
      old_path = File.join(upload_path, file)
      new_path = File.join(upload_path, new_name)
      
      if (new_name.blank?)
        flash[:error] = "You must specify a file name."
        redirect "/file/rename?file=#{file}"
      end
      
      if (new_name == file)
        flash[:error] = "The new name must be different than the old name."
        redirect "/file/rename?file=#{file}"
      end
      
      if (!File.exists?(old_path))
        flash[:error] = "File doesn't exist."
        redirect '/files'
      end
      
      FileUtils.move old_path, new_path
      
      flash[:info] = "File renamed."
      redirect '/files'
    end
    
    
    get '/file/delete/confirm/?', :auth => :admin do
      file = params[:file]
      file = File.join(upload_path, file)
      
      if (!File.exists?(file))
        flash[:error] = "File doesn't exist."
        redirect '/files'
      end
      
      File.delete(file)
      flash[:info] = "File deleted."
      redirect '/files'
    end
    
    get '/file/delete/?', :auth => :admin do 
      @file = params[:file]
      
      path = File.join(upload_path, @file)
      
      if (!File.exists?(path))
        flash[:error] = "File doesn't exist."
        redirect '/files'
      end
      
      erb :"files/delete"
    end
    
    get '/file/detail/?' do
      @page_title = @file
      @file = params[:file]
      
      path = File.join(upload_path, @file)
      
      if (!File.exists?(path))
        flash[:error] = "File doesn't exist."
        redirect '/files'
      end
      
      erb :"files/detail"
    end
    
    post '/files/upload', :auth => :approved  do
      file = params[:file]
      redirect_url = params[:redirect]
      
      if (redirect_url.blank?)
        redirect_url = "/files/upload"
      end
      
      if (!file)
        flash[:error] = "No file selected."
        redirect redirect_url
      end
      
      tempfile = file[:tempfile]
      name = AresMUSH::Website::FilenameSanitizer.sanitize params[:filename]
      allow_overwrite = params[:allow_overwrite] ? params[:allow_overwrite] : false
            
      if (!tempfile || name.blank?)
        flash[:error] = "Missing file or filename."
        redirect redirect_url
      end
      
      max_upload_kb = Global.read_config("website", "max_upload_size_kb")
      if (file_size_kb(tempfile) > max_upload_kb)
        flash[:error] = "Max upload size is #{max_upload_kb}kB."
        redirect redirect_url
      end
      
      file_path = File.join(upload_path, name)
      
      if (File.exists?(file_path) && !allow_overwrite)
        flash[:error] = "That file already exists."
        redirect redirect_url
      end
            
      File.open(file_path, 'wb') {|f| f.write tempfile.read }
      flash[:info] = "File uploaded!"
      redirect redirect_url
    end
    
    get '/files/:name/' do |name|
      send_file "/files/#{name.downcase}"
    end
  end
end