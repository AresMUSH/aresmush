module AresMUSH
  class WebApp
     
    get '/admin/config_web', :auth => :admin do
      @config = Global.read_config("website")
      
      erb :"admin/config_web"
    end
    
    post '/admin/config_web/update', :auth => :admin do
      
      @config = Global.read_config("website")
      
      @config['website_tagline'] = @params[:website_tagline]
      @config['website_welcome'] = @params[:website_welcome]
      
      config = { 
        "website" => @config
      }
      write_config_file File.join(AresMUSH.game_path, 'plugins', 'website', 'config_website.yml'), config.to_yaml
      
      flash[:info] = "Saved!"
      Manage.reload_config
      
      redirect '/admin'
    end
        
  end
end
