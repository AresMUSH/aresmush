module AresMUSH
  class WebApp
    get '/admin/config_secrets', :auth => :admin do    
      @secrets = Global.read_config("secrets")
      
      @recaptcha_secret = Global.read_config("secrets", "recaptcha", "secret")
      @recaptcha_site_key = Global.read_config("secrets", "recaptcha", "site_key")
      
      @events_calendar = Global.read_config("secrets", "events", "calendar")
      @events_api_key = Global.read_config("secrets", "events", "api_key")
      
      @aws_key_id = Global.read_config("secrets", "aws", "key_id")
      @aws_secret_key = Global.read_config("secrets", "aws", "secret_key")
      @aws_bucket = Global.read_config("secrets", "aws", "bucket")
      @aws_region = Global.read_config("secrets", "aws", "region")
      
      @wikidot_api_key = Global.read_config("secrets", "wikidot", "api_key")
      
      erb :"admin/config_secrets"
    end
    
    post '/admin/config_secrets/update', :auth => :admin do
      
      @secrets = Global.read_config("secrets")      
      
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
      @secrets['aws'] = {
        'key_id' => @params[:aws_key_id],
        'secret_key' => @params[:aws_secret_key],
        'bucket' => @params[:aws_bucket],
        'region' => @params[:aws_region]
      }
      @secrets['wikidot'] = {
        'api_key' => @params[:wikidot_api_key]
      }
      
      config = {
        'secrets' => @secrets
      }
      write_config_file File.join(AresMUSH.game_path, 'config', 'secrets.yml'), config.to_yaml
    
      
      flash[:info] = "Saved!"
      Manage.reload_config
      
      redirect '/admin'
    end
        
  end
end
