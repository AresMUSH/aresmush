module AresMUSH
  class WebApp
    get '/admin/game_prefs', :auth => :admin do
      @date = Global.read_config("date_and_time")
      @names = Global.read_config("names")
      @secrets = Global.read_config("secrets")
      @skin = Global.read_config("skin")
      
      @recaptcha_secret = Global.read_config("secrets", "recaptcha", "secret")
      @recaptcha_site_key = Global.read_config("secrets", "recaptcha", "site_key")
      
      @events_calendar = Global.read_config("secrets", "events", "calendar")
      @events_api_key = Global.read_config("secrets", "events", "api_key")
      
      erb :"admin/game_prefs"
    end
    
    post '/admin/game_prefs/update', :auth => :admin do
      
      @date = Global.read_config("date_and_time")
      @names = Global.read_config("names")
      @secrets = Global.read_config("secrets")
      @skin = Global.read_config("skin")
      # ----------------
      # Date Time
      # ----------------
      @date['short_date_format'] = @params[:short_date_format]
      @date['long_date_format'] = @params[:long_date_format]
      @date['time_format'] = @params[:time_format]
      @date['date_entry_format_help'] = @params[:date_entry_format_help]
      
      config = { 
        "date_and_time" => @date
      }
      write_config_file File.join(AresMUSH.game_path, 'config', 'date_and_time.yml'), config.to_yaml

      # ----------------
      # Names
      # ----------------

      @names['restricted'] = @params[:restricted_names].split("\r\n").map { |n| n.downcase }
      config = {
        'names' => @names
      }
      write_config_file File.join(AresMUSH.game_path, 'config', 'names.yml'), config.to_yaml
      
      # ----------------
      # Secrets
      # ----------------
      
      @secrets['events'] = {
        'calendar' => @params[:events_calendar],
        'api_key' => @params[:events_api_key]
      }
      @secrets['recaptcha'] = {
        'secret' => @params[:recaptcha_secret],
        'site_key' => @params[:recaptcha_site_key]
      }
      
      config = {
        'secrets' => @secrets
      }
      write_config_file File.join(AresMUSH.game_path, 'config', 'secrets.yml'), config.to_yaml
      
      # ----------------
      # Lines
      # ----------------
      
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
