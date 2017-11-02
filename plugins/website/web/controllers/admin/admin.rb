module AresMUSH
  class WebApp    
    get '/admin/?', :auth => :admin do
      @reboot_required = File.exist?('/var/run/reboot-required')
      erb :"admin/admin_index"
    end
    
  end
end
