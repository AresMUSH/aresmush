module AresMUSH
  class WebApp
    
    post '/admin/config/update', :auth => :admin do
      
      config = params[:contents]
      path = params[:path]
      plugin = params[:plugin]
      
      error = nil
      begin
        if (path.end_with?(".yml"))
          YAML::load(config)
        end
      rescue Exception => ex
        error = true
      end
      
      File.open(File.join(AresMUSH.root_path, path), 'w') do |f|
        f.write config
      end
      
      if (error)
        redirect "/admin/config/edit?path=#{path}&plugin=#{plugin}"
      else
        flash[:info] = "Saved!"
        reload_config        
        redirect params[:return_url] || '/config'
      end
    end
    
  end
end
