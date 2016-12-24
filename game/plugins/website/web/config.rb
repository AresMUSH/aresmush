module AresMUSH
  class WebApp
    get '/config', :auth => :admin do
      @game_config = ConfigReader.config_files.map { |f| File.basename(f) }
      @plugin_config = {}
      Global.plugin_manager.plugins.each do |p|
        p.config_files.each do |f|
          @plugin_config[f] = p.to_s.after('::').downcase
        end
      end
      erb :config_index
    end
    
    get '/config/:plugin/:file', :auth => :admin do |plugin, file|
      @plugin = plugin
      @filename = file
      if (@plugin == "game")        
        @config = File.read(File.join(AresMUSH.game_path, "config", file))
      elsif (@plugin == "files")
        @config = File.read(File.join(AresMUSH.game_path, "files", file))
      else
        @config = File.read(File.join(AresMUSH.game_path, "plugins", plugin, file))
      end
      
      @error = nil      
      
      begin
        if (@plugin != "files")
          YAML::load(@config)
        end
      rescue Exception => ex
        @error = "There's a problem with the format of your YAML file.  Please check your formatting and review the tips in the <a href=\"http://www.aresmush.com\">YAML configuration tutorial</a>.  Error: #{ex}"
      end
      
      erb :config
    end
    
    post '/config/update/:plugin/:file', :auth => :admin do |plugin, file|
      config = params[:config]
      error = nil
      begin
        if (plugin != "files")
          YAML::load(config)
        end
      rescue Exception => ex
        error = true
      end
      
      if (plugin == "game")        
        path = File.join(AresMUSH.game_path, "config", file)
      elsif (plugin == "files")
        path = File.join(AresMUSH.game_path, "files", file)
      else
        path = File.join(AresMUSH.game_path, "plugins", plugin, file)
      end
            
      File.open(path, 'w') do |f|
        f.write config
      end
      
      if (error)
        redirect "/config/#{plugin}/#{file}"
      else
        flash[:info] = "Saved!"
        Manage::Api.reload_config
        redirect "/config"
      end
    end
    
  end
end
