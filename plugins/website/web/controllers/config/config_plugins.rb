module AresMUSH
  class WebApp
    get '/admin/config_plugins/?', :auth => :admin do
      @plugins = Global.read_config("plugins", "optional_plugins")
      @disabled = Global.read_config("plugins", "disabled_plugins")
      erb :"admin/config_plugins"
    end
    
    post '/admin/config_plugins/update', :auth => :admin do
      
      @plugins = Global.read_config("plugins")
      
      previously_disabled = @plugins['disabled_plugins']
      
      @plugins['disabled_plugins'] = []
      optional_plugins = Global.read_config("plugins", "optional_plugins")
      optional_plugins.each do |p|
        if (!@params['plugins'].include?(p))
          @plugins['disabled_plugins'] << p
        end
      end
      
      config = {
        'plugins' => @plugins
      }
      write_config_file File.join(AresMUSH.game_path, 'config', 'plugins.yml'), config.to_yaml
      
      changed_plugins = (previously_disabled | @plugins['disabled_plugins']) - (previously_disabled & @plugins['disabled_plugins'])
      
      connector = AresMUSH::EngineApiConnector.new
      connector.plugins_changed(changed_plugins)
      
      
      flash[:info] = "Saved!"
      reload_config
      redirect '/admin'
    end
        
  end
end
