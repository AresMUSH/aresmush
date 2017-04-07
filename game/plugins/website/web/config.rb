module AresMUSH
  class WebApp
    get '/config', :auth => :admin do
      game_path = AresMUSH.game_path
      @game_config = ConfigReader.config_files.map { |f| f.gsub(game_path, "") }
      @plugin_config = {}
      Global.plugin_manager.plugins.each do |p|
        plugin_name = p.to_s.after('::').downcase
        
        @plugin_config[plugin_name] = {}
        @plugin_config[plugin_name]["help"] = p.help_files.map { |f| File.join("plugins", plugin_name, f) }
        @plugin_config[plugin_name]["locale"] = p.locale_files.map { |f| File.join("plugins", plugin_name, f) }
        @plugin_config[plugin_name]["config"] = p.config_files.map { |f| File.join("plugins", plugin_name, f) }
        
        template_files = Dir[File.join(game_path, "plugins", plugin_name, "templates", "**.erb")]
        @plugin_config[plugin_name]["templates"] = template_files.map { |f| f.gsub(game_path, "") }
        
      end
      erb :config_index
    end
    
    get '/config/edit', :auth => :admin do
      
      @path = params[:path]
      @title = params[:title] || @path
      @config = File.read(File.join(AresMUSH.game_path, @path))
      @error = nil      
      @return_url = params[:return_url] || '/config'
      
      begin
        if (@path.end_with?(".yml"))
          YAML::load(@config)
        end
      rescue Exception => ex
        @error = "There's a problem with the format of your YAML file.  Please check your formatting and review the tips in the <a href=\"http://www.aresmush.com\">YAML configuration tutorial</a>.  Error: #{ex}"
      end
      
      erb :config
    end
    
    post '/config/update', :auth => :admin do
      
      config = params[:config]
      path = params[:path]
      title = params[:title]
      
      error = nil
      begin
        if (path.end_with?(".yml"))
          YAML::load(config)
        end
      rescue Exception => ex
        error = true
      end
      
      File.open(File.join(AresMUSH.game_path, path), 'w') do |f|
        f.write config
      end
      
      if (error)
        redirect "/config/edit?path=#{path}&title=#{title}"
      else
        flash[:info] = "Saved!"
        Manage::Api.reload_config
        redirect params[:return_url] || '/config'
      end
    end
    
  end
end
