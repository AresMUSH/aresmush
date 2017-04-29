module AresMUSH
  class WebApp
    get '/admin/config_skin', :auth => :admin do
      
      @skin = Global.read_config("skin")      
      
      erb :"admin/config_skin"
    end
    
    post '/admin/config_skin/update', :auth => :admin do
      
      @skin = Global.read_config("skin")
      
      @skin['line1'] =@params[:line1]
      @skin['line2'] =@params[:line2]
      @skin['line3'] =@params[:line3]
      @skin['line4'] =@params[:line4]
      
      config = {
        'skin' => @skin
      }
      
      write_config_file File.join(AresMUSH.game_path, 'config', 'skin.yml'), config.to_yaml
      
      
      flash[:info] = "Saved!"
      Manage::Api.reload_config
      
      redirect '/admin'
    end
        
  end
end
