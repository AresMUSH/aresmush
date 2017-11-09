module AresMUSH
  class WebApp    
    helpers do
      def reload_config
        connector = EngineApiConnector.new
        error = connector.reload_config
        if (error)
          flash[:info] = nil
          flash[:error] = "Error saving config: #{error}"
        end
      end
    end
    
    get '/admin/?', :auth => :admin do
      @reboot_required = File.exist?('/var/run/reboot-required')
      erb :"admin/admin_index"
    end
    
  end
end
