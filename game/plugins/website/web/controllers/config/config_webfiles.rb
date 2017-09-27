module AresMUSH
  class WebApp
    
    helpers do
      
      def website_file_path
        File.join(AresMUSH.game_path, 'plugins', 'website', 'web', 'public', 'images')
      end
      
    end
    
    get '/admin/config_web_header_bg/?', :auth => :admin do
      @name = "Web Header"
      @hint = "Displayed as the background across the top header."
      @dest_path = website_file_path
      @filename = "background.png"      
      erb :"admin/upload"
    end
    
    get '/admin/config_web_box_bg/?', :auth => :admin do
      @name = "Web Char/Log Box Background"
      @hint = "Displayed as a background on log and character info boxes."
      @dest_path = website_file_path
      @filename = "box-bg.png"
      erb :"admin/upload"
    end
    
    
    get '/admin/config_web_home_image/?', :auth => :admin do
      @name = "Web Home Image"
      @hint = "Displayed on the home page."
      @dest_path = website_file_path
      @filename = "jumbotron.png"
      erb :"admin/upload"
    end
    
    get '/admin/config_web_favicon/?', :auth => :admin do
      @name = "Web Favicon"
      @hint = "The little icon shown in the tab bar of most browsers."
      @dest_path = website_file_path
      @filename = "favicon.ico"
      erb :"admin/upload"
    end
    
    post '/admin/upload', :auth => :admin  do
      file = params[:file]
      
      if (!file)
        flash[:error] = "No file selected."
        redirect '/admin'
      end
      
      tempfile = file[:tempfile]
      name = params[:filename]
      
      if (!tempfile || !name)
        flash[:error] = "Missing file or filename."
        redirect '/admin'
      end
      
      file_path = File.join(website_file_path, name)
      
      File.open(file_path, 'wb') {|f| f.write tempfile.read }
      flash[:info] = "File uploaded!  You'll probably need to force a browser refresh for it to load the new version."
      redirect '/admin'
    end
    
  end
end
