module AresMUSH
  class WebApp
    get '/admin/config_secrets/?', :auth => :admin do    
      @secrets = Global.read_config("secrets")
      
      @recaptcha_secret = Global.read_config("secrets", "recaptcha", "secret")
      @recaptcha_site_key = Global.read_config("secrets", "recaptcha", "site_key")
      
      @aws_key_id = Global.read_config("secrets", "aws", "key_id")
      @aws_secret_key = Global.read_config("secrets", "aws", "secret_key")
      @aws_bucket = Global.read_config("secrets", "aws", "bucket")
      @aws_region = Global.read_config("secrets", "aws", "region")
            
      erb :"admin/config_secrets"
    end
    
    post '/admin/config_secrets/update', :auth => :admin do
      
      @secrets = Global.read_config("secrets")      
      
      # ----------------
      # Secrets
      # ----------------
            
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
