module AresMUSH
  class WebApp
    get '/admin/config_sites/?', :auth => :admin do
      @sites = Global.read_config("sites")

      erb :"admin/config_sites"
    end
    
    post '/admin/config_sites/update', :auth => :admin do
      
      @sites = Global.read_config("sites")
      
      @sites['banned'] = @params[:banned_sites].split("\r\n").map { |n| n.downcase }
      @sites['suspect'] = @params[:suspect_sites].split("\r\n").map { |n| n.downcase }
      @sites['ban_proxies'] = !!@params[:ban_proxies]
      config = {
        'sites' => @sites
      }
      write_config_file File.join(AresMUSH.game_path, 'config', 'sites.yml'), config.to_yaml
      
      
      flash[:info] = "Saved!"
      reload_config
      redirect '/admin'
    end
        
  end
end
