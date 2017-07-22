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
    
    get '/files' do
      @files = uploaded_files
      erb :"files/index"
    end
    
    get '/files/upload', :auth => :approved  do
      erb :"files/upload"
    end
    
    get '/file/delete', :auth => :approved do
      file = params[:file]
      if (!File.exists?(file))
        flash[:error] = "File doesn't exist."
        redirect '/files'
      end
      
      File.delete(file)
      flash[:info] = "File deleted."
      redirect '/files'
    end
    
    post '/files/upload', :auth => :approved  do
      file = params[:file]
      
      if (!file)
        flash[:error] = "No file selected."
        redirect '/files/upload'
      end
      
      tempfile = file[:tempfile]
      name = params[:filename]
      
      if (!tempfile || !name)
        flash[:error] = "Missing file or filename."
        redirect '/files/upload'
      end
      
      max_upload_kb = Global.read_config("website", "max_upload_size_kb")
      if (file_size_kb(tempfile) > max_upload_kb)
        flash[:error] = "Max upload size is #{max_upload_kb}kB."
        redirect '/files/upload'
      end
      
      file_path = File.join(upload_path, name)
      
      if (File.exists?(file_path))
        flash[:error] = "That file already exists."
        redirect '/files'
      end
            
      File.open(file_path, 'wb') {|f| f.write tempfile.read }
      flash[:info] = "File uploaded!"
      redirect '/files'
    end
  end
end