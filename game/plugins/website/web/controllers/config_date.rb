module AresMUSH
  class WebApp
    get '/admin/config_date', :auth => :admin do
      @date = Global.read_config("date_and_time")
      
      erb :"admin/config_date"
    end
    
    post '/admin/config_date/update', :auth => :admin do
      
      @date = Global.read_config("date_and_time")
      
      @date['short_date_format'] = @params[:short_date_format]
      @date['long_date_format'] = @params[:long_date_format]
      @date['time_format'] = @params[:time_format]
      @date['date_entry_format_help'] = @params[:date_entry_format_help]
      
      config = { 
        "date_and_time" => @date
      }
      write_config_file File.join(AresMUSH.game_path, 'config', 'date_and_time.yml'), config.to_yaml
      
      flash[:info] = "Saved!"
      Manage::Api.reload_config
      
      redirect '/admin'
    end
        
  end
end
